defmodule Dovecot.Pigeons.Pigeon do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "pigeons" do
    field :loft_id, :binary_id
    field :name, :string
    field :ring, :string

    timestamps()
  end

  @doc false
  def changeset(pigeon, attrs) do
    pigeon
    |> cast(attrs, [:loft_id, :ring, :name])
    |> validate_required(:ring)
    |> unique_constraint([:loft_id, :ring])
  end
end
