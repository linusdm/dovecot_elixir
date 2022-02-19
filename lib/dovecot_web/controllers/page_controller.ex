defmodule DovecotWeb.PageController do
  use DovecotWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
