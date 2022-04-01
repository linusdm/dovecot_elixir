defmodule Dovecot.Races.Price do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "races_prices" do
    field :loft_id, :binary_id, primary_key: true
    field :race_id, :binary_id, primary_key: true
    field :pigeon_id, :binary_id, primary_key: true
    field :category, Ecto.Enum, values: [:jong, :jaarling, :oud], primary_key: true
    field :rayon_id, :binary_id, primary_key: true
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:race_id, :pigeon_id, :category, :rayon_id, :price])
    |> validate_required([:race_id, :pigeon_id, :category, :rayon_id, :price])
  end
end
