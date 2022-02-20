defmodule Dovecot.PigeonsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dovecot.Pigeons` context.
  """

  @doc """
  Generate a unique pigeon ring.
  """
  def unique_pigeon_ring, do: "some ring#{System.unique_integer([:positive])}"

  @doc """
  Generate a pigeon.
  """
  def pigeon_fixture(attrs \\ %{}) do
    {:ok, pigeon} =
      attrs
      |> Enum.into(%{
        name: "some name",
        ring: unique_pigeon_ring()
      })
      |> Dovecot.Pigeons.create_pigeon()

    pigeon
  end
end
