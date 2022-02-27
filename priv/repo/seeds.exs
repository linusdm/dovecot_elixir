# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dovecot.Repo.insert!(%Dovecot.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Dovecot.Factory

loft = insert(:loft, %{name: "test loft"})

insert_list(10, :pigeon, %{loft_id: loft.loft_id})

insert(:user, %{email: "some@email.com", password: "hello Dovecot!", loft_id: loft.loft_id})
