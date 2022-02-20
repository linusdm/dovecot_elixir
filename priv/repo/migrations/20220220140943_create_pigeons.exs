defmodule Dovecot.Repo.Migrations.CreatePigeons do
  use Ecto.Migration

  def change do
    create table(:pigeons, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :loft_id, references(:lofts, on_delete: :delete_all, type: :binary_id), null: false
      add :ring, :string, null: false
      add :name, :string

      timestamps()
    end

    create unique_index(:pigeons, [:loft_id, :ring])
    create index(:pigeons, [:loft_id])
  end
end
