defmodule Dovecot.RacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dovecot.Races` context.
  """

  @doc """
  Generate a unique race name.
  """
  def unique_race_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a race.
  """
  def race_fixture(attrs \\ %{}) do
    {:ok, race} =
      attrs
      |> Enum.into(%{
        distance: 42,
        name: unique_race_name(),
        release_date: ~D[2022-02-28],
        release_time: ~T[14:00:00]
      })
      |> Dovecot.Races.create_race()

    race
  end
end
