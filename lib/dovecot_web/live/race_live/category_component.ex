defmodule DovecotWeb.RaceLive.CategoryComponent do
  use DovecotWeb, :live_component

  alias Dovecot.Races

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:race, assigns.race)
     |> assign(:category, assigns.category)
     |> assign(:path, assigns.path)
     |> init_assigns()}
  end

  @impl true
  def handle_event("save", %{"constatations" => constatations_params}, socket) do
    case Races.bulk_update_constatations(socket.assigns.changeset.data, constatations_params) do
      :ok ->
        {:noreply, socket |> put_flash(:info, "saved!") |> push_redirect(to: socket.assigns.path)}

      {:nochange, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("moved", %{"from" => from, "to" => to}, socket) do
    from = Enum.at(socket.assigns.rows, from).category_participation
    to = Enum.at(socket.assigns.rows, to).category_participation
    Races.move_category_participation(from, to)
    {:noreply, socket |> put_flash(:info, "moved!") |> push_redirect(to: socket.assigns.path)}
  end

  defp init_assigns(%{assigns: %{myself: myself, category: category, race: race}} = socket) do
    rows = Races.get_category_participations(race, category)
    participations = Enum.map(rows, fn %{participation: participation} -> participation end)
    changeset = Races.change_constatations(race.release_date, participations)

    socket
    |> assign(:rows, rows)
    |> assign(:changeset, changeset)
    |> assign(
      :constatation_form,
      Phoenix.HTML.FormData.to_form(changeset,
        id: "constatation_form_#{myself}",
        as: "constatations"
      )
    )
  end

  def hidden_inputs_in_parent_form_for(form, parent_form) do
    Enum.map(form.hidden, fn {k, v} ->
      hidden_input(form, k, form: parent_form.id, value: v)
    end)
  end
end
