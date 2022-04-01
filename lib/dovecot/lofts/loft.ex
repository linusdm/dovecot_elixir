defmodule Dovecot.Lofts.Loft do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:loft_id, :binary_id, autogenerate: true}
  schema "lofts" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(loft, attrs) do
    loft
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
