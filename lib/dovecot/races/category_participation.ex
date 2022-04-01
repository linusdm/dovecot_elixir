defmodule Dovecot.Races.CategoryParticipation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "races_category_participations" do
    belongs_to :loft, Dovecot.Lofts.Loft, references: :loft_id, primary_key: true
    belongs_to :race, Dovecot.Races.Race, primary_key: true
    belongs_to :pigeon, Dovecot.Pigeons.Pigeon, primary_key: true

    field :category, Ecto.Enum, values: [:jong, :jaarling, :oud], primary_key: true
    field :rank, :integer

    timestamps()
  end

  @doc false
  def changeset(category_participation, attrs) do
    category_participation
    |> cast(attrs, [:race_id, :pigeon_id, :category, :rank])
    |> validate_required([:race_id, :pigeon_id, :category, :rank])
  end
end
