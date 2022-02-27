defmodule DovecotWeb.PigeonLiveTest do
  use DovecotWeb.ConnCase

  import Phoenix.LiveViewTest
  import Dovecot.Factory

  @update_attrs %{name: "some updated name", ring: "some updated ring"}
  @invalid_attrs %{name: nil, ring: nil}

  defp create_pigeon(%{user: user}) do
    %{pigeon: insert(:pigeon, %{loft_id: user.loft_id})}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_pigeon]

    test "lists all pigeons", %{conn: conn, pigeon: pigeon} do
      {:ok, _index_live, html} = live(conn, Routes.pigeon_index_path(conn, :index))

      assert html =~ "Listing Pigeons"
      assert html =~ pigeon.name
    end

    test "saves new pigeon", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.pigeon_index_path(conn, :index))

      assert index_live |> element("a", "New Pigeon") |> render_click() =~
               "New Pigeon"

      assert_patch(index_live, Routes.pigeon_index_path(conn, :new))

      assert index_live
             |> form("#pigeon-form", pigeon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      create_attrs = @update_attrs

      {:ok, _, html} =
        index_live
        |> form("#pigeon-form", pigeon: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pigeon_index_path(conn, :index))

      assert html =~ "Pigeon created successfully"
      assert html =~ create_attrs[:name]
    end

    test "updates pigeon in listing", %{conn: conn, pigeon: pigeon} do
      {:ok, index_live, _html} = live(conn, Routes.pigeon_index_path(conn, :index))

      assert index_live |> element("#pigeon-#{pigeon.id} a", "Edit") |> render_click() =~
               "Edit Pigeon"

      assert_patch(index_live, Routes.pigeon_index_path(conn, :edit, pigeon))

      assert index_live
             |> form("#pigeon-form", pigeon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#pigeon-form", pigeon: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pigeon_index_path(conn, :index))

      assert html =~ "Pigeon updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes pigeon in listing", %{conn: conn, pigeon: pigeon} do
      {:ok, index_live, _html} = live(conn, Routes.pigeon_index_path(conn, :index))

      assert index_live |> element("#pigeon-#{pigeon.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pigeon-#{pigeon.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_pigeon]

    test "displays pigeon", %{conn: conn, pigeon: pigeon} do
      {:ok, _show_live, html} = live(conn, Routes.pigeon_show_path(conn, :show, pigeon))

      assert html =~ "Show Pigeon"
      assert html =~ pigeon.name
    end

    test "updates pigeon within modal", %{conn: conn, pigeon: pigeon} do
      {:ok, show_live, _html} = live(conn, Routes.pigeon_show_path(conn, :show, pigeon))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pigeon"

      assert_patch(show_live, Routes.pigeon_show_path(conn, :edit, pigeon))

      assert show_live
             |> form("#pigeon-form", pigeon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#pigeon-form", pigeon: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.pigeon_show_path(conn, :show, pigeon))

      assert html =~ "Pigeon updated successfully"
      assert html =~ "some updated name"
    end
  end
end
