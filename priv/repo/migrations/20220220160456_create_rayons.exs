defmodule Dovecot.Repo.Migrations.CreateRayons do
  use Ecto.Migration

  def change do
    create table(:rayons, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :loft_id,
          references(:lofts, column: :loft_id, on_delete: :delete_all, type: :binary_id),
          null: false

      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:rayons, [:loft_id, :name])
    create index(:rayons, [:loft_id])
  end
end
