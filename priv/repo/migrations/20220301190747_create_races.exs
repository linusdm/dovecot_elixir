defmodule Dovecot.Repo.Migrations.CreateRaces do
  use Ecto.Migration

  def change do
    create table(:races, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :loft_id,
          references(:lofts, column: :loft_id, on_delete: :delete_all, type: :binary_id),
          null: false

      add :name, :string, null: false
      add :distance, :integer
      add :release_date, :date, null: false
      add :release_time, :time

      timestamps()
    end

    create unique_index(:races, [:loft_id, :name, :release_date])
    create unique_index(:races, [:loft_id, :id])
    create index(:races, [:loft_id])
  end
end
