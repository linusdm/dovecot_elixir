defmodule Dovecot.PigeonsTest do
  use Dovecot.DataCase

  alias Dovecot.Pigeons

  describe "pigeons" do
    alias Dovecot.Pigeons.Pigeon

    import Dovecot.Factory

    @invalid_attrs %{name: nil, ring: nil}

    setup do
      loft = insert(:loft)
      Dovecot.Repo.put_loft_id(loft.loft_id)
      %{loft: loft, pigeon: insert(:pigeon, %{loft_id: loft.loft_id})}
    end

    test "list_pigeons/0 returns all pigeons", %{pigeon: pigeon} do
      assert Pigeons.list_pigeons() == [pigeon]
    end

    test "get_pigeon!/1 returns the pigeon with given id", %{pigeon: pigeon} do
      assert Pigeons.get_pigeon!(pigeon.id) == pigeon
    end

    test "create_pigeon/1 with valid data creates a pigeon", %{loft: loft} do
      valid_attrs = params_for(:pigeon, %{loft_id: loft.loft_id})

      assert {:ok, %Pigeon{} = pigeon} = Pigeons.create_pigeon(valid_attrs)
      assert pigeon.ring == valid_attrs[:ring]
      assert pigeon.name == valid_attrs[:name]
    end

    test "create_pigeon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pigeons.create_pigeon(@invalid_attrs)
    end

    test "update_pigeon/2 with valid data updates the pigeon", %{pigeon: pigeon} do
      update_attrs = %{name: "some updated name", ring: "some updated ring"}

      assert {:ok, %Pigeon{} = pigeon} = Pigeons.update_pigeon(pigeon, update_attrs)
      assert pigeon.name == "some updated name"
      assert pigeon.ring == "some updated ring"
    end

    test "update_pigeon/2 with invalid data returns error changeset", %{pigeon: pigeon} do
      assert {:error, %Ecto.Changeset{}} = Pigeons.update_pigeon(pigeon, @invalid_attrs)
      assert pigeon == Pigeons.get_pigeon!(pigeon.id)
    end

    test "delete_pigeon/1 deletes the pigeon", %{pigeon: pigeon} do
      assert {:ok, %Pigeon{}} = Pigeons.delete_pigeon(pigeon)
      assert_raise Ecto.NoResultsError, fn -> Pigeons.get_pigeon!(pigeon.id) end
    end

    test "change_pigeon/1 returns a pigeon changeset", %{pigeon: pigeon} do
      assert %Ecto.Changeset{} = Pigeons.change_pigeon(pigeon)
    end
  end
end
