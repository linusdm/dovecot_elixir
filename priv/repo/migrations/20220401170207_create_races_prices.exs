defmodule Dovecot.Repo.Migrations.CreateRacesPrices do
  use Ecto.Migration

  def change do
    create table(:races_prices, primary_key: false) do
      add :loft_id, :binary_id, primary_key: true
      add :race_id, :binary_id, primary_key: true
      add :pigeon_id, :binary_id, primary_key: true

      add :category,
          references(:races_category_participations,
            column: :category,
            with: [loft_id: :loft_id, race_id: :race_id, pigeon_id: :pigeon_id],
            match: :full,
            on_delete: :delete_all,
            type: :string
          ),
          primary_key: true

      add :rayon_id,
          references(:rayons,
            column: :id,
            with: [loft_id: :loft_id],
            match: :full,
            on_delete: :restrict,
            type: :binary_id
          ),
          primary_key: true

      add :price, :integer, null: false

      timestamps()
    end

    create unique_index(:races_prices, [:loft_id, :race_id, :category, :rayon_id, :price])

    create index(:races_prices, [:loft_id])
    create index(:races_prices, [:race_id])
    create index(:races_prices, [:pigeon_id])
    create index(:races_prices, [:rayon_id])
  end
end
