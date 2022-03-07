defmodule Dovecot.Races.Participation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "races_participations" do
    belongs_to :loft, Dovecot.Lofts.Loft,
      references: :loft_id,
      type: :binary_id,
      primary_key: true

    belongs_to :race, Dovecot.Races.Race, type: :binary_id, primary_key: true
    belongs_to :pigeon, Dovecot.Pigeons.Pigeon, type: :binary_id, primary_key: true

    field :constatation, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(participation, attrs) do
    participation
    |> cast(attrs, [:pigeon_id, :race_id, :constatation])
    |> validate_required([:pigeon_id, :race_id])
  end
end
