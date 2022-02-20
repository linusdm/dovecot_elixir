defmodule DovecotWeb.PigeonLive.FormComponent do
  use DovecotWeb, :live_component

  alias Dovecot.Pigeons

  @impl true
  def update(%{pigeon: pigeon} = assigns, socket) do
    changeset = Pigeons.change_pigeon(pigeon)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"pigeon" => pigeon_params}, socket) do
    changeset =
      socket.assigns.pigeon
      |> Pigeons.change_pigeon(pigeon_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"pigeon" => pigeon_params}, socket) do
    save_pigeon(socket, socket.assigns.action, pigeon_params)
  end

  defp save_pigeon(socket, :edit, pigeon_params) do
    case Pigeons.update_pigeon(socket.assigns.pigeon, pigeon_params) do
      {:ok, _pigeon} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pigeon updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_pigeon(socket, :new, pigeon_params) do
    case Pigeons.create_pigeon(pigeon_params) do
      {:ok, _pigeon} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pigeon created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
