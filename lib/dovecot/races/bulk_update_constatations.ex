defmodule Dovecot.Races.BulkUpdateConstatations do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dovecot.Races.RelativeDateTime
  alias Dovecot.Races.Participation

  @primary_key false
  embedded_schema do
    embeds_many :values, Constatation, primary_key: false do
      field :pigeon_id, :binary_id, primary_key: true
      field :race_id, :binary_id, primary_key: true
      field :start_date, :date
      embeds_one :participation, Participation
      field :relative_datetime, RelativeDateTime
    end
  end

  def create(%Date{} = start_date, participations) do
    %__MODULE__{
      values:
        Enum.map(participations, fn %Participation{} = participation ->
          %__MODULE__.Constatation{
            pigeon_id: participation.pigeon_id,
            participation: participation,
            start_date: start_date,
            relative_datetime: RelativeDateTime.create(start_date, participation.constatation)
          }
        end)
    }
  end

  @doc false
  def changeset(%__MODULE__{} = bulk_update, attrs) do
    bulk_update
    |> cast(attrs, [])
    |> cast_embed(:values, with: &child_changeset/2)
  end

  defp child_changeset(schema, params), do: cast(schema, params, [:relative_datetime])

  def to_participation_changesets(bulk_update_changeset) do
    case Ecto.Changeset.fetch_change(bulk_update_changeset, :values) do
      {:ok, constatation_changesets} ->
        constatation_changesets
        |> Enum.filter(&match?({:ok, _}, fetch_change(&1, :relative_datetime)))
        |> Enum.map(fn changeset ->
          relative_datetime = fetch_change!(changeset, :relative_datetime)

          constatation =
            RelativeDateTime.get_datetime(changeset.data.start_date, relative_datetime)

          change(changeset.data.participation, constatation: constatation)
        end)

      :error ->
        []
    end
  end
end
