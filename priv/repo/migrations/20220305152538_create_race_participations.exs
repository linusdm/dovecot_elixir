defmodule Dovecot.Repo.Migrations.CreateRaceParticipations do
  use Ecto.Migration

  def change do
    create table(:race_participations, primary_key: false) do
      add :loft_id,
          references(:lofts, column: :loft_id, on_delete: :delete_all, type: :binary_id),
          primary_key: true

      add :race_id,
          references(:races,
            with: [loft_id: :loft_id],
            match: :full,
            on_delete: :delete_all,
            type: :binary_id
          ),
          primary_key: true

      add :pigeon_id,
          references(:pigeons,
            with: [loft_id: :loft_id],
            match: :full,
            on_delete: :delete_all,
            type: :binary_id
          ),
          primary_key: true

      add :constatation, :naive_datetime

      timestamps()
    end

    create index(:race_participations, [:loft_id])
    create index(:race_participations, [:race_id])
    create index(:race_participations, [:pigeon_id])
  end
end
