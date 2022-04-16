defmodule Dovecot.Races.BulkUpdatePrices do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :values, Price, primary_key: false do
      field :pigeon_id, :binary_id, primary_key: true
      embeds_one :price, Dovecot.Races.Price
    end
  end

  def create(prices, loft_id, race_id, category, rayon_id) do
    %__MODULE__{
      values:
        prices
        |> Enum.map(fn
          %__MODULE__.Price{pigeon_id: pigeon_id, price: nil} = value ->
            %{
              value
              | price: %Dovecot.Races.Price{
                  loft_id: loft_id,
                  race_id: race_id,
                  category: category,
                  rayon_id: rayon_id,
                  pigeon_id: pigeon_id,
                  price: nil
                }
            }

          value ->
            value
        end)
    }
  end

  @doc false
  def changeset(%__MODULE__{} = bulk_update, attrs) do
    bulk_update
    |> cast(attrs, [])
    |> cast_embed(:values, with: &child_changeset/2)
  end

  defp child_changeset(schema, params),
    do: cast(schema, params, []) |> cast_embed(:price, with: &cast(&1, &2, [:price]))

  def to_price_changesets(bulk_update_changeset) do
    case fetch_change(bulk_update_changeset, :values) do
      {:ok, price_changesets} ->
        price_changesets
        |> Enum.filter(&match?({:ok, _}, fetch_change(&1, :price)))
        |> Enum.map(&fetch_change!(&1, :price))
        # Remove action of changeset so it can be used with any Repo function.
        # The action is set by cast_embed when building the changeset,
        # but it collides with how we use the changeset eventually.
        |> Enum.map(&Map.put(&1, :action, nil))

      :error ->
        []
    end
  end
end
