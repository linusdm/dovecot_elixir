defmodule Dovecot.Lofts do
  @moduledoc """
  The Lofts context.
  """

  import Ecto.Query, warn: false
  alias Dovecot.Repo

  alias Dovecot.Lofts.Loft

  @doc """
  Returns the list of lofts.

  ## Examples

      iex> list_lofts()
      [%Loft{}, ...]

  """
  def list_lofts do
    Repo.all(Loft)
  end

  @doc """
  Gets a single loft.

  Raises `Ecto.NoResultsError` if the Loft does not exist.

  ## Examples

      iex> get_loft!(123)
      %Loft{}

      iex> get_loft!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loft!(id), do: Repo.get!(Loft, id)

  @doc """
  Creates a loft.

  ## Examples

      iex> create_loft(%{field: value})
      {:ok, %Loft{}}

      iex> create_loft(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loft(attrs \\ %{}) do
    %Loft{}
    |> Loft.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loft.

  ## Examples

      iex> update_loft(loft, %{field: new_value})
      {:ok, %Loft{}}

      iex> update_loft(loft, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loft(%Loft{} = loft, attrs) do
    loft
    |> Loft.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loft.

  ## Examples

      iex> delete_loft(loft)
      {:ok, %Loft{}}

      iex> delete_loft(loft)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loft(%Loft{} = loft) do
    Repo.delete(loft)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loft changes.

  ## Examples

      iex> change_loft(loft)
      %Ecto.Changeset{data: %Loft{}}

  """
  def change_loft(%Loft{} = loft, attrs \\ %{}) do
    Loft.changeset(loft, attrs)
  end
end
