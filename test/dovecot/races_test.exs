defmodule Dovecot.RacesTest do
  use Dovecot.DataCase

  alias Ecto.Changeset
  alias Dovecot.Races

  describe "races" do
    alias Dovecot.Races.Race

    import Dovecot.Factory

    @invalid_attrs %{distance: nil, name: nil, release_date: nil, release_time: nil}

    setup do
      loft = insert(:loft)
      Dovecot.Repo.put_loft_id(loft.loft_id)
      %{loft: loft}
    end

    test "list_races/0 returns all races", %{loft: loft} do
      race = insert(:race, %{loft_id: loft.loft_id})
      assert Races.list_races() == [race]
    end

    test "get_race!/1 returns the race with given id", %{loft: loft} do
      race = insert(:race, %{loft_id: loft.loft_id})
      assert Races.get_race!(race.id) == race
    end

    test "create_race/1 with valid data creates a race", %{loft: loft} do
      valid_attrs = %{
        distance: 50_000,
        name: "some name",
        release_date: ~D[2022-02-28],
        release_time: ~T[14:00:00]
      }

      assert {:ok, %Race{} = race} = Races.create_race(valid_attrs)
      assert race.loft_id == loft.loft_id
      assert race.distance == 50_000
      assert race.name == "some name"
      assert race.release_date == ~D[2022-02-28]
      assert race.release_time == ~T[14:00:00]
    end

    test "create_race/1 with invalid data returns error changeset" do
      assert {:error, %Changeset{}} = Races.create_race(@invalid_attrs)
    end

    test "update_race/2 with valid data updates the race", %{loft: loft} do
      race = insert(:race, %{loft_id: loft.loft_id})

      update_attrs = %{
        distance: 50_000,
        name: "some updated name",
        release_date: ~D[2022-03-01],
        release_time: ~T[15:01:01]
      }

      assert {:ok, %Race{} = race} = Races.update_race(race, update_attrs)
      assert race.distance == 50_000
      assert race.name == "some updated name"
      assert race.release_date == ~D[2022-03-01]
      assert race.release_time == ~T[15:01:01]
    end

    test "update_race/2 with invalid data returns error changeset", %{loft: loft} do
      race = insert(:race, %{loft_id: loft.loft_id})
      assert {:error, %Changeset{}} = Races.update_race(race, @invalid_attrs)
      assert race == Races.get_race!(race.id)
    end

    test "delete_race/1 deletes the race", %{loft: loft} do
      race = insert(:race, %{loft_id: loft.loft_id})
      assert {:ok, %Race{}} = Races.delete_race(race)
      assert_raise Ecto.NoResultsError, fn -> Races.get_race!(race.id) end
    end

    test "change_race/1 returns a race changeset" do
      race = build(:race)
      assert %Changeset{} = Races.change_race(race)
    end

    test "apply_suggestion/2" do
      race = build(:race, name: "original", distance: 1000, release_date: ~D[2000-01-01])

      changeset =
        Race.changeset(race, %{
          "name" => "new",
          "distance" => "2000",
          "release_date" => "2000-01-02"
        })

      suggestion = build(:race, name: "suggested", distance: 3000, release_date: "2000-01-03")

      applied_changeset = Races.apply_race_suggestion(changeset, suggestion)

      assert Changeset.fetch_change!(applied_changeset, :name) == suggestion.name
      assert Changeset.fetch_change!(applied_changeset, :distance) == suggestion.distance

      assert Changeset.fetch_change!(applied_changeset, :release_date) ==
               Changeset.fetch_change!(changeset, :release_date)
    end
  end
end
