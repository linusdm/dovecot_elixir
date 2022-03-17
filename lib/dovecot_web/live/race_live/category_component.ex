defmodule DovecotWeb.RaceLive.CategoryComponent do
  use DovecotWeb, :live_component

  alias Dovecot.Races
  alias Dovecot.Races.EmbeddedConstatations
  alias Dovecot.Races.EmbeddedConstatations.Constatation

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    rows = Races.get_blah(assigns.race, assigns.category)

    constatations = %EmbeddedConstatations{
      values:
        Enum.map(rows, fn row ->
          %Constatation{pigeon_id: row.pigeon_id, constatation: row.constatation}
        end)
    }

    changeset = EmbeddedConstatations.changeset(constatations, %{})

    {:ok,
     socket
     |> assign(:rows, rows)
     |> assign(:constatations, constatations)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", params, socket) do
    changeset =
      EmbeddedConstatations.changeset(
        socket.assigns.constatations,
        params["constatations"]
      )

    IO.inspect(changeset)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def with_form(rows, forms) do
    Enum.zip(rows, forms)
  end
end
