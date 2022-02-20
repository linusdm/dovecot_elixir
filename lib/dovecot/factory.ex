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
      |> evaluate_lazy_attributes()
    )
    |> Ecto.Changeset.apply_changes()
  end

  def loft_factory do
    %Dovecot.Lofts.Loft{
      name: "some loft"
    }
  end

  def pigeon_factory do
    %Dovecot.Pigeons.Pigeon{
      ring: sequence(:pigeon_ring, &"some ring#{&1}"),
      name: "some name"
    }
  end
end
