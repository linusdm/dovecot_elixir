defmodule DovecotWeb.PigeonLive.Index do
  use DovecotWeb, :live_view

  alias Dovecot.Pigeons
  alias Dovecot.Pigeons.Pigeon

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :pigeons, list_pigeons())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pigeon")
    |> assign(:pigeon, Pigeons.get_pigeon!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pigeon")
    |> assign(:pigeon, %Pigeon{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pigeons")
    |> assign(:pigeon, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pigeon = Pigeons.get_pigeon!(id)
    {:ok, _} = Pigeons.delete_pigeon(pigeon)

    {:noreply, assign(socket, :pigeons, list_pigeons())}
  end

  defp list_pigeons do
    Pigeons.list_pigeons()
  end
end
