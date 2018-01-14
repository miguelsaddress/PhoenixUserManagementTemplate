defmodule MyAppWeb.LayoutView do
  use MyAppWeb, :view

  alias MyApp.Accounts

  def current_user(conn) do
    conn.assigns[:user]
  end

  def is_user_signed_in(conn) do
    current_user(conn) != nil
  end

  def user_is_admin(conn) do
    user = current_user(conn)
    user && Accounts.is_admin_role(user.role)
  end

  def signup_enabled do
    Application.get_env(:my_app, :signup_enabled)
  end
end
