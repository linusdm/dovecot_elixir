defmodule Dovecot.Races.EmbeddedConstatations do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :values, Constatation, on_replace: :delete, primary_key: false do
      field :pigeon_id, :binary_id, primary_key: true
      field :constatation, :naive_datetime
    end
  end

  @doc false
  def changeset(%__MODULE__{} = constatations, attrs) do
    constatations
    |> cast(attrs, [])
    |> cast_embed(:values, with: &child_changeset/2)
  end

  defp child_changeset(schema, params) do
    schema
    |> cast(params, [:constatation])
  end
end
