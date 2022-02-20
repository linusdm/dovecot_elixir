defmodule Dovecot.Pigeons do
  @moduledoc """
  The Pigeons context.
  """

  import Ecto.Query, warn: false
  alias Dovecot.Repo

  alias Dovecot.Pigeons.Pigeon

  @doc """
  Returns the list of pigeons.

  ## Examples

      iex> list_pigeons()
      [%Pigeon{}, ...]

  """
  def list_pigeons do
    Repo.all(Pigeon)
  end

  @doc """
  Gets a single pigeon.

  Raises `Ecto.NoResultsError` if the Pigeon does not exist.

  ## Examples

      iex> get_pigeon!(123)
      %Pigeon{}

      iex> get_pigeon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pigeon!(id), do: Repo.get!(Pigeon, id)

  @doc """
  Creates a pigeon.

  ## Examples

      iex> create_pigeon(%{field: value})
      {:ok, %Pigeon{}}

      iex> create_pigeon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pigeon(attrs \\ %{}) do
    %Pigeon{}
    |> Pigeon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pigeon.

  ## Examples

      iex> update_pigeon(pigeon, %{field: new_value})
      {:ok, %Pigeon{}}

      iex> update_pigeon(pigeon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pigeon(%Pigeon{} = pigeon, attrs) do
    pigeon
    |> Pigeon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pigeon.

  ## Examples

      iex> delete_pigeon(pigeon)
      {:ok, %Pigeon{}}

      iex> delete_pigeon(pigeon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pigeon(%Pigeon{} = pigeon) do
    Repo.delete(pigeon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pigeon changes.

  ## Examples

      iex> change_pigeon(pigeon)
      %Ecto.Changeset{data: %Pigeon{}}

  """
  def change_pigeon(%Pigeon{} = pigeon, attrs \\ %{}) do
    Pigeon.changeset(pigeon, attrs)
  end
end
