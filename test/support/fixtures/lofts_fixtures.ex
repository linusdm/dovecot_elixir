defmodule Dovecot.LoftsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dovecot.Lofts` context.
  """

  @doc """
  Generate a loft.
  """
  def loft_fixture(attrs \\ %{}) do
    {:ok, loft} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Dovecot.Lofts.create_loft()

    loft
  end
end
