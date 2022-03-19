defmodule Dovecot.Races do
  @moduledoc """
  The Races context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Dovecot.Repo
  alias Dovecot.Races.BulkUpdateConstatations

  alias Dovecot.Races.{Race, Participation, CategoryParticipation}

  @doc """
  Returns the list of races.

  ## Examples

      iex> list_races()
      [%Race{}, ...]

  """
  def list_races do
    Repo.all(Race)
  end

  @doc """
  Gets a single race.

  Raises `Ecto.NoResultsError` if the Race does not exist.

  ## Examples

      iex> get_race!(123)
      %Race{}

      iex> get_race!(456)
      ** (Ecto.NoResultsError)

  """
  def get_race!(id), do: Repo.get!(Race, id)

  def get_race_by_release_date_and_name!(release_date, name),
    do: Repo.get_by!(Race, release_date: release_date, name: name)

  def get_race_with_matching_name("" = _name), do: []

  def get_race_with_matching_name(name) do
    Repo.all(
      from r in Race,
        where: not is_nil(r.distance),
        where: ilike(r.name, ^"%#{name}%"),
        order_by: [desc: r.release_date],
        limit: 10
    )
  end

  @doc """
  Creates a race.

  ## Examples

      iex> create_race(%{field: value})
      {:ok, %Race{}}

      iex> create_race(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_race(attrs \\ %{}) do
    %Race{loft_id: Dovecot.Repo.get_loft_id()}
    |> Race.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a race.

  ## Examples

      iex> update_race(race, %{field: new_value})
      {:ok, %Race{}}

      iex> update_race(race, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_race(%Race{} = race, attrs) do
    race
    |> Race.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a race.

  ## Examples

      iex> delete_race(race)
      {:ok, %Race{}}

      iex> delete_race(race)
      {:error, %Ecto.Changeset{}}

  """
  def delete_race(%Race{} = race) do
    Repo.delete(race)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking race changes.

  ## Examples

      iex> change_race(race)
      %Ecto.Changeset{data: %Race{}}

  """
  def change_race(%Race{} = race, attrs \\ %{}) do
    Race.changeset(race, attrs)
  end

  def apply_race_suggestion(%{data: %Race{} = race, params: attrs}, %Race{} = suggestion) do
    merged_attrs =
      attrs
      |> Map.put("name", suggestion.name)
      |> Map.put("distance", suggestion.distance)

    Race.changeset(race, merged_attrs)
  end

  def get_category_participations(%Race{id: race_id}, category) do
    from(p in Participation,
      join: cp in CategoryParticipation,
      on: [loft_id: p.loft_id, race_id: p.race_id, pigeon_id: p.pigeon_id],
      join: pi in assoc(p, :pigeon),
      where: cp.race_id == ^race_id,
      where: cp.category == ^category,
      order_by: cp.rank,
      select: %{
        participation: p,
        category_participation: cp,
        pigeon: pi
      }
    )
    |> Repo.all()
  end

  def change_constatations(%Date{} = start_date, participations, attrs \\ %{}) do
    BulkUpdateConstatations.create(start_date, participations)
    |> BulkUpdateConstatations.changeset(attrs)
  end

  def bulk_update_constatations(%BulkUpdateConstatations{} = bulk_update, attrs) do
    case BulkUpdateConstatations.changeset(bulk_update, attrs) do
      %Ecto.Changeset{valid?: true, changes: %{values: _constatation_changesets}} = changeset ->
        BulkUpdateConstatations.to_participation_changesets(changeset)
        |> Enum.with_index()
        |> Enum.reduce(Multi.new(), fn {changeset, index}, multi ->
          Multi.update(multi, {:constatation, index}, changeset)
        end)
        |> Repo.transaction()

        :ok

      %Ecto.Changeset{valid?: true} ->
        :ok

      changeset ->
        {:error, changeset}
    end
  end
end
