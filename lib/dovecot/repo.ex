defmodule Dovecot.Repo do
  use Ecto.Repo,
    otp_app: :dovecot,
    adapter: Ecto.Adapters.Postgres
end
