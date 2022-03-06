defmodule Dovecot.Races.CategoryParticipation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "races_category_participations" do
    field :loft_id, :binary_id, primary_key: true
    field :race_id, :binary_id, primary_key: true
    field :pigeon_id, :binary_id, primary_key: true
    field :category, Ecto.Enum, values: [:jong, :jaarling, :oud], primary_key: true

    timestamps()
  end

  @doc false
  def changeset(category_participation, attrs) do
    category_participation
    |> cast(attrs, [:pigeon_id, :race_id, :category])
    |> validate_required([:pigeon_id, :race_id, :category])
  end
end
