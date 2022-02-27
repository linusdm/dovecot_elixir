defmodule DovecotWeb.UserLiveAuth do
  alias Phoenix.LiveView
  alias Dovecot.Accounts

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      LiveView.assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    Dovecot.Repo.put_loft_id(socket.assigns[:current_user].loft_id)

    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:halt, LiveView.redirect(socket, to: "/users/log_in")}
    end
  end
end
