defmodule DovecotWeb.RaceLive.CategoryComponent do
  use DovecotWeb, :live_component

  alias Dovecot.Races
  alias Phoenix.HTML.FormData

  @impl true
  def mount(socket), do: {:ok, socket}

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:race, assigns.race)
     |> assign(:category, assigns.category)
     |> assign(:path, assigns.path)
     |> init_constatations_assigns()
     |> init_prices_assigns()}
  end

  defp init_constatations_assigns(
         %{assigns: %{myself: myself, category: category, race: race}} = socket
       ) do
    rows = Races.get_category_participations(race, category)
    participations = rows |> Enum.map(&Map.fetch!(&1, :participation))
    constatations_changeset = Races.change_constatations(race.release_date, participations)

    socket
    |> assign(:rows, rows)
    |> assign(:constatations_changeset, constatations_changeset)
    |> assign(
      :constatations_form,
      constatations_changeset
      |> FormData.to_form(id: "constatations_form_#{myself}", as: "constatations")
    )
  end

  defp init_prices_assigns(%{assigns: %{myself: myself, category: category, race: race}} = socket) do
    prices_changesets_and_forms =
      Races.change_prices(race, category)
      |> Enum.into(%{}, fn {%Dovecot.Rayons.Rayon{} = rayon, changeset} ->
        {rayon,
         %{
           changeset: changeset,
           form:
             changeset |> FormData.to_form(id: "prices_form_#{myself}_#{rayon.id}", as: "prices")
         }}
      end)

    socket |> assign(:prices_changesets_and_forms, prices_changesets_and_forms)
  end

  @impl true
  def handle_event("save", %{"constatations" => constatations_params}, socket) do
    case Races.bulk_update_constatations(
           socket.assigns.constatations_changeset.data,
           constatations_params
         ) do
      :ok ->
        {:noreply, socket |> put_flash(:info, "saved!") |> push_redirect(to: socket.assigns.path)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:constatations_changeset, changeset)
         |> assign(
           :constatations_form,
           changeset
           |> FormData.to_form(
             id: "constatations_form_#{socket.assigns.myself}",
             as: "constatations"
           )
         )}
    end
  end

  @impl true
  def handle_event("save", %{"prices" => %{"rayon_id" => rayon_id} = attrs}, socket) do
    {rayon, %{changeset: %{data: data}}} =
      Enum.find(socket.assigns.prices_changesets_and_forms, fn {rayon, _} ->
        rayon.id == rayon_id
      end)

    case Races.bulk_update_prices(data, attrs) do
      :ok ->
        {:noreply, socket |> put_flash(:info, "saved!") |> push_redirect(to: socket.assigns.path)}

      {:error, %Ecto.Changeset{} = changeset} ->
        form =
          changeset
          |> FormData.to_form(
            id: "prices_form_#{socket.assigns.myself}_#{rayon.id}",
            as: "prices"
          )

        prices_changesets_and_forms =
          socket.assigns.prices_changesets_and_forms
          |> Map.put(rayon, %{changeset: changeset, form: form})

        {:noreply, assign(socket, :prices_changesets_and_forms, prices_changesets_and_forms)}
    end
  end

  @impl true
  def handle_event("moved", %{"from" => from, "to" => to}, socket) do
    from = Enum.at(socket.assigns.rows, from).category_participation
    to = Enum.at(socket.assigns.rows, to).category_participation
    Races.move_category_participation(from, to)
    {:noreply, socket |> put_flash(:info, "moved!") |> push_redirect(to: socket.assigns.path)}
  end

  def to_price_form_per_pigeon(prices_changesets_and_forms) do
    prices_changesets_and_forms
    |> Enum.map(fn {_, %{form: form}} ->
      inputs_for(form, :values)
      |> Enum.map(fn price_form -> %{bulk_form: form, price_form: price_form} end)
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def hidden_inputs_in_parent_form_for(form, parent_form) do
    Enum.map(form.hidden, fn {k, v} ->
      hidden_input(form, k, value: v, form: parent_form.id)
    end)
  end
end
