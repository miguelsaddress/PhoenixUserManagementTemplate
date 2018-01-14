defmodule MyAppWeb.Plugs.RequireAdmin do
  import Plug.Conn
  import Phoenix.Controller

  alias MyAppWeb.Router.Helpers
  alias MyApp.Accounts


  def init([]) do
    # nothing to do here
  end

  def call(conn, _params) do
    if (conn.assigns.user && Accounts.is_admin_role(conn.assigns.user.role)) do
      conn
    else
      conn
      |> put_flash(:error, "You must be an admin to be here.")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end

  end
end
