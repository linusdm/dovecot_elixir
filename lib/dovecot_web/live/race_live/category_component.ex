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
        {:noreply, push_redirect(socket, to: socket.assigns.path)}

      {:nochange, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp init_assigns(%{assigns: %{category: category, race: race}} = socket) do
    rows = Races.get_category_participations(race, category)
    participations = Enum.map(rows, fn %{participation: participation} -> participation end)
    changeset = Races.change_constatations(race.release_date, participations)

    socket
    |> assign(:rows, rows)
    |> assign(:changeset, changeset)
  end

  def with_form(rows, forms) do
    Enum.zip(rows, forms)
  end
end
