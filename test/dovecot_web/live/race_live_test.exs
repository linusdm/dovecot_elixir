defmodule DovecotWeb.RaceLiveTest do
  use DovecotWeb.ConnCase

  import Phoenix.LiveViewTest
  import Dovecot.Factory

  @invalid_attrs %{name: nil, distance: 1, release_date: nil, release_time: nil}
  @update_attrs %{
    name: "some updated name",
    distance: 1000,
    release_date: ~D[2022-01-01],
    release_time: ~T[07:30:00.000]
  }

  setup [:register_and_log_in_user]

  test "saves new race", %{conn: conn} do
    {:ok, form_live, _html} = live(conn, Routes.race_form_path(conn, :new))

    assert form_live
           |> form("#race-form", race: @invalid_attrs)
           |> render_change() =~ "can&#39;t be blank"

    create_attrs = @update_attrs

    {:ok, _, html} =
      form_live
      |> form("#race-form", race: create_attrs)
      |> render_submit()
      |> follow_redirect(
        conn,
        Routes.race_form_path(
          conn,
          :edit,
          Date.to_iso8601(create_attrs[:release_date]),
          create_attrs[:name]
        )
      )

    assert html =~ "Race created successfully"
    assert html =~ create_attrs[:name]
  end

  test "can apply suggestion while creating new race", %{conn: conn, user: user} do
    suggestion =
      insert(:race,
        loft_id: user.loft_id,
        name: "suggested",
        distance: 3000,
        release_date: "2000-01-03"
      )

    {:ok, form_live, _html} = live(conn, Routes.race_form_path(conn, :new))

    form_live
    |> form("#race-form", race: @update_attrs)
    |> render_change()

    assert form_live
           |> form("#race-form", race: %{name: "sug"})
           |> render_change(%{_target: ["race", "name"]}) =~ suggestion.name

    result =
      form_live
      |> element("div", "suggested")
      |> render_click()

    refute has_element?(element(form_live, "div", "suggested"))

    assert result =~ suggestion.name
    assert result =~ "#{suggestion.distance}"
    assert result =~ Date.to_iso8601(@update_attrs[:release_date])
  end
end
