defmodule DovecotWeb.RaceLive.Details do
  use DovecotWeb, :live_view

  alias Dovecot.Races

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"date" => date, "name" => name}, uri, socket) do
    race = Races.get_race_by_release_date_and_name!(date, name)
    %URI{path: path} = URI.parse(uri)
    {:noreply, assign(socket, race: race, path: path)}
  end
end
