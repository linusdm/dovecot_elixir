defmodule DovecotWeb.RaceLive.Form do
  use DovecotWeb, :live_view

  alias Dovecot.Races
  alias Dovecot.Races.Race
  alias Ecto.Changeset

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"date" => date, "name" => name}) do
    race = Races.get_race_by_release_date_and_name!(date, name)

    socket
    |> assign(:title, "Edit Race")
    |> assign(:race, race)
    |> assign(:changeset, Races.change_race(race))
    |> assign(:suggestions, [])
  end

  defp apply_action(socket, :new, _params) do
    race = %Race{loft_id: Dovecot.Repo.get_loft_id()}

    socket
    |> assign(:title, "New Race")
    |> assign(:race, race)
    |> assign(:changeset, Races.change_race(race))
    |> assign(:suggestions, [])
  end

  @impl true
  def handle_event("validate", %{"race" => race_params} = params, socket) do
    socket =
      socket
      |> validate_params(race_params)
      |> update_suggestions(params)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"race" => race_params}, socket) do
    save_race(socket, socket.assigns.live_action, race_params)
  end

  @impl true
  def handle_event("apply_suggestion", %{"race_id" => race_id}, socket) do
    suggestion = Enum.find(socket.assigns[:suggestions], fn s -> s.id == race_id end)

    new_changeset =
      Changeset.change(socket.assigns[:changeset],
        name: suggestion.name,
        distance: suggestion.distance
      )

    socket =
      socket
      |> assign(:suggestions, [])
      |> assign(:changeset, new_changeset)
      |> validate_params(new_changeset.changes)

    {:noreply, socket}
  end

  defp validate_params(socket, race_params) do
    changeset =
      socket.assigns.race
      |> Races.change_race(race_params)
      |> Map.put(:action, :validate)

    assign(socket, :changeset, changeset)
  end

  defp update_suggestions(
         %{assigns: %{live_action: :new}} = socket,
         %{"_target" => ["race", "name"] = path} = params
       ) do
    suggestions = Races.get_race_with_matching_name(get_in(params, path))
    assign(socket, :suggestions, suggestions)
  end

  defp update_suggestions(socket, _params) do
    socket
  end

  defp save_race(socket, :edit, race_params) do
    case Races.update_race(socket.assigns.race, race_params) do
      {:ok, race} ->
        {:noreply,
         socket
         |> put_flash(:info, "Race updated successfully")
         |> push_redirect(
           to: Routes.race_form_path(socket, :edit, Date.to_iso8601(race.release_date), race.name)
         )}

      {:error, %Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_race(socket, :new, race_params) do
    case Races.create_race(Map.put(race_params, "loft_id", Dovecot.Repo.get_loft_id())) do
      {:ok, race} ->
        {:noreply,
         socket
         |> put_flash(:info, "Race created successfully")
         |> push_redirect(
           to: Routes.race_form_path(socket, :edit, Date.to_iso8601(race.release_date), race.name)
         )}

      {:error, %Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
