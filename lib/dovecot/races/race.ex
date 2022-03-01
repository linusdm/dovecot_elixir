defmodule Dovecot.Races.Race do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "races" do
    field :loft_id, :binary_id
    field :name, :string
    field :distance, :integer
    field :release_date, :date
    field :release_time, :time

    timestamps()
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:loft_id, :name, :distance, :release_date, :release_time])
    |> validate_required([:loft_id, :name, :release_date])
    |> unique_constraint([:loft_id, :name, :release_date])
  end
end
