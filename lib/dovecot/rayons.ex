defmodule Dovecot.Rayons do
  @moduledoc """
  The Rayons context.
  """

  import Ecto.Query, warn: false
  alias Dovecot.Repo

  alias Dovecot.Rayons.Rayon

  @doc """
  Returns the list of rayons.

  ## Examples

      iex> list_rayons()
      [%Rayon{}, ...]

  """
  def list_rayons do
    Repo.all(Rayon)
  end

  @doc """
  Gets a single rayon.

  Raises `Ecto.NoResultsError` if the Rayon does not exist.

  ## Examples

      iex> get_rayon!(123)
      %Rayon{}

      iex> get_rayon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rayon!(id), do: Repo.get!(Rayon, id)

  @doc """
  Creates a rayon.

  ## Examples

      iex> create_rayon(%{field: value})
      {:ok, %Rayon{}}

      iex> create_rayon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rayon(attrs \\ %{}) do
    %Rayon{}
    |> Rayon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rayon.

  ## Examples

      iex> update_rayon(rayon, %{field: new_value})
      {:ok, %Rayon{}}

      iex> update_rayon(rayon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rayon(%Rayon{} = rayon, attrs) do
    rayon
    |> Rayon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rayon.

  ## Examples

      iex> delete_rayon(rayon)
      {:ok, %Rayon{}}

      iex> delete_rayon(rayon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rayon(%Rayon{} = rayon) do
    Repo.delete(rayon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rayon changes.

  ## Examples

      iex> change_rayon(rayon)
      %Ecto.Changeset{data: %Rayon{}}

  """
  def change_rayon(%Rayon{} = rayon, attrs \\ %{}) do
    Rayon.changeset(rayon, attrs)
  end
end
