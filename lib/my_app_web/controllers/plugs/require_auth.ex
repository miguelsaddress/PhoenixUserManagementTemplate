defmodule MyAppWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias MyAppWeb.Router.Helpers


  def init([]) do
    # nothing to do here
  end

  def call(conn, _params) do
    IO.inspect(conn)
    if (conn.assigns.user) do
      conn
    else
      conn
      |> put_flash(:error, "You must be signed in.")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end

  end
end
