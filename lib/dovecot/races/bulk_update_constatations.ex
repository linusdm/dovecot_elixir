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

  defp child_changeset(schema, params) do
    schema
    |> cast(params, [:relative_datetime])
  end

  def to_participation_changesets(constatation_changesets) do
    constatation_changesets
    |> Enum.filter(fn changeset -> fetch_change(changeset, :relative_datetime) != :error end)
    |> Enum.map(fn changeset ->
      relative_datetime = fetch_change!(changeset, :relative_datetime)
      constatation = RelativeDateTime.get_datetime(changeset.data.start_date, relative_datetime)

      change(changeset.data.participation, constatation: constatation)
    end)
  end
end
