defmodule Dovecot.RayonsTest do
  use Dovecot.DataCase

  alias Dovecot.Rayons

  describe "rayons" do
    alias Dovecot.Rayons.Rayon

    import Dovecot.Factory

    @invalid_attrs %{name: nil}

    setup do
      loft = insert(:loft)
      Dovecot.Repo.put_loft_id(loft.loft_id)
      %{loft: loft, rayon: insert(:rayon, %{loft_id: loft.loft_id})}
    end

    test "list_rayons/0 returns all rayons", %{rayon: rayon} do
      assert Rayons.list_rayons() == [rayon]
    end

    test "get_rayon!/1 returns the rayon with given id", %{rayon: rayon} do
      assert Rayons.get_rayon!(rayon.id) == rayon
    end

    test "create_rayon/1 with valid data creates a rayon", %{loft: loft} do
      valid_attrs = params_for(:rayon, %{loft_id: loft.loft_id})

      assert {:ok, %Rayon{} = rayon} = Rayons.create_rayon(valid_attrs)
      assert rayon.name == valid_attrs[:name]
    end

    test "create_rayon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rayons.create_rayon(@invalid_attrs)
    end

    test "update_rayon/2 with valid data updates the rayon", %{rayon: rayon} do
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Rayon{} = rayon} = Rayons.update_rayon(rayon, update_attrs)
      assert rayon.name == "some updated name"
    end

    test "update_rayon/2 with invalid data returns error changeset", %{rayon: rayon} do
      assert {:error, %Ecto.Changeset{}} = Rayons.update_rayon(rayon, @invalid_attrs)
      assert rayon == Rayons.get_rayon!(rayon.id)
    end

    test "delete_rayon/1 deletes the rayon", %{rayon: rayon} do
      assert {:ok, %Rayon{}} = Rayons.delete_rayon(rayon)
      assert_raise Ecto.NoResultsError, fn -> Rayons.get_rayon!(rayon.id) end
    end

    test "change_rayon/1 returns a rayon changeset", %{rayon: rayon} do
      assert %Ecto.Changeset{} = Rayons.change_rayon(rayon)
    end
  end
end
