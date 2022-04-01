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

    # A `deferrable initially deferred` constraint is needed to allow ranks to be updated with the
    # constraint being temporarily violated within the transaction. Afterwards the constraint should
    # hold up again.
    # create unique_index(:races_category_participations, [:loft_id, :race_id, :category, :rank])
    execute "ALTER TABLE races_category_participations ADD CONSTRAINT races_category_participations_loft_id_race_id_category_rank_index
             UNIQUE (loft_id, race_id, category, rank)
             DEFERRABLE INITIALLY DEFERRED",
            "ALTER TABLE races_category_participations
             DROP CONSTRAINT IF EXISTS races_category_participations_loft_id_race_id_category_rank_index"

    create index(:races_category_participations, [:loft_id])
    create index(:races_category_participations, [:race_id])
    create index(:races_category_participations, [:pigeon_id])
  end
end
