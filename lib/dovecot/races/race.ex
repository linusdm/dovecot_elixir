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
    |> validate_number(:distance, greater_than_or_equal_to: 1000, less_than_or_equal_to: 5_000_000)
    |> unsafe_validate_unique([:loft_id, :name, :release_date], Dovecot.Repo,
      error_key: :name,
      message: "er is al een race met deze naam op dezelfde dag"
    )
    |> unique_constraint([:loft_id, :name, :release_date])
  end
end
