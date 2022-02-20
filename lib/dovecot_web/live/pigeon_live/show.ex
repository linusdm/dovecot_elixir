defmodule DovecotWeb.PigeonLive.Show do
  use DovecotWeb, :live_view

  alias Dovecot.Pigeons

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pigeon, Pigeons.get_pigeon!(id))}
  end

  defp page_title(:show), do: "Show Pigeon"
  defp page_title(:edit), do: "Edit Pigeon"
end
