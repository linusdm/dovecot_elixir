defmodule Dovecot.Repo.Migrations.CreateCategoryParticipations do
  use Ecto.Migration

  def change do
    create table(:races_category_participations, primary_key: false) do
      add :loft_id, :binary_id, primary_key: true
      add :race_id, :binary_id, primary_key: true

      add :pigeon_id,
          references(:races_participations,
            column: :pigeon_id,
            with: [loft_id: :loft_id, race_id: :race_id],
            match: :full,
            on_delete: :delete_all,
            type: :binary_id
          ),
          primary_key: true

      add :category, :string, primary_key: true
      add :rank, :integer, null: false

      timestamps()
    end

    create unique_index(:races_category_participations, [:loft_id, :race_id, :category, :rank])
    create index(:races_category_participations, [:loft_id])
    create index(:races_category_participations, [:race_id])
    create index(:races_category_participations, [:pigeon_id])
  end
end
