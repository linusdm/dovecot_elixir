defmodule Dovecot.LoftsTest do
  use Dovecot.DataCase

  alias Dovecot.Lofts

  describe "lofts" do
    alias Dovecot.Lofts.Loft

    import Dovecot.LoftsFixtures

    @invalid_attrs %{name: nil}

    test "list_lofts/0 returns all lofts" do
      loft = loft_fixture()
      assert Lofts.list_lofts() == [loft]
    end

    test "get_loft!/1 returns the loft with given id" do
      loft = loft_fixture()
      assert Lofts.get_loft!(loft.id) == loft
    end

    test "create_loft/1 with valid data creates a loft" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Loft{} = loft} = Lofts.create_loft(valid_attrs)
      assert loft.name == "some name"
    end

    test "create_loft/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lofts.create_loft(@invalid_attrs)
    end

    test "update_loft/2 with valid data updates the loft" do
      loft = loft_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Loft{} = loft} = Lofts.update_loft(loft, update_attrs)
      assert loft.name == "some updated name"
    end

    test "update_loft/2 with invalid data returns error changeset" do
      loft = loft_fixture()
      assert {:error, %Ecto.Changeset{}} = Lofts.update_loft(loft, @invalid_attrs)
      assert loft == Lofts.get_loft!(loft.id)
    end

    test "delete_loft/1 deletes the loft" do
      loft = loft_fixture()
      assert {:ok, %Loft{}} = Lofts.delete_loft(loft)
      assert_raise Ecto.NoResultsError, fn -> Lofts.get_loft!(loft.id) end
    end

    test "change_loft/1 returns a loft changeset" do
      loft = loft_fixture()
      assert %Ecto.Changeset{} = Lofts.change_loft(loft)
    end
  end
end
