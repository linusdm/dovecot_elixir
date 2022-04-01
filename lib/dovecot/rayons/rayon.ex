defmodule Dovecot.Rayons.Rayon do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "rayons" do
    field :loft_id, :binary_id
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(rayon, attrs) do
    rayon
    |> cast(attrs, [:loft_id, :name])
    |> validate_required([:loft_id, :name])
    |> unique_constraint([:loft_id, :name])
  end
end
