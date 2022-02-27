defmodule Dovecot.Repo.Migrations.CreateLofts do
  use Ecto.Migration

  def change do
    create table(:lofts, primary_key: false) do
      add :loft_id, :binary_id, primary_key: true
      add :name, :string, null: false

      timestamps()
    end
  end
end
