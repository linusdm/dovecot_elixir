defmodule Dovecot.Races.BulkUpdateConstatations do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :values, Constatation, primary_key: false do
      field :pigeon_id, :binary_id, primary_key: true
      field :start_date, :date
      embeds_one :participation, Dovecot.Races.Participation
      field :relative_datetime, Dovecot.Races.RelativeDateTime
    end
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
end
