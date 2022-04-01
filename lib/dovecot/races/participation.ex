defmodule Dovecot.Races.Participation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "races_participations" do
    belongs_to :loft, Dovecot.Lofts.Loft, references: :loft_id, primary_key: true
    belongs_to :race, Dovecot.Races.Race, primary_key: true
    belongs_to :pigeon, Dovecot.Pigeons.Pigeon, primary_key: true

    field :constatation, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(participation, attrs) do
    participation
    |> cast(attrs, [:race_id, :pigeon_id, :constatation])
    |> validate_required([:race_id, :pigeon_id])
  end
end
