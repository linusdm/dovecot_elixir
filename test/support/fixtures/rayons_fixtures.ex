defmodule Dovecot.RayonsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dovecot.Rayons` context.
  """

  @doc """
  Generate a unique rayon name.
  """
  def unique_rayon_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a rayon.
  """
  def rayon_fixture(attrs \\ %{}) do
    {:ok, rayon} =
      attrs
      |> Enum.into(%{
        name: unique_rayon_name()
      })
      |> Dovecot.Rayons.create_rayon()

    rayon
  end
end
