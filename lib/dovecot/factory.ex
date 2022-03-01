defmodule Dovecot.Factory do
  use ExMachina.Ecto, repo: Dovecot.Repo

  def user_factory(attrs) do
    %Dovecot.Accounts.User{}
    |> Dovecot.Accounts.User.registration_changeset(
      %{
        email: sequence(:email, &"user#{&1}@dovecot.com"),
        password: "ILoveDovecot4Ever!"
      }
      |> merge_attributes(attrs)
    )
    |> Ecto.Changeset.apply_changes()
  end

  def loft_factory, do: %Dovecot.Lofts.Loft{name: "some loft"}

  def pigeon_factory do
    %Dovecot.Pigeons.Pigeon{
      ring: sequence(:pigeon_ring, &"some ring#{&1}"),
      name: "some name"
    }
  end

  def rayon_factory, do: %Dovecot.Rayons.Rayon{name: sequence(:rayon_name, &"some name#{&1}")}

  def race_factory do
    %Dovecot.Races.Race{
      name: "some name",
      distance: 745,
      release_date: ~D[2000-02-28],
      release_time: ~T[07:30:00]
    }
  end
end
