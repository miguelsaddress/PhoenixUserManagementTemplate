defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  alias MyApp.Accounts
  alias MyApp.Accounts.User

  #a user must be signed in to access these actions
  # plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  # plug MyAppWeb.Plugs.RequireAuth when action in [:new, :edit, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset, roles: Accounts.list_roles)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, roles: Accounts.list_roles)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user_with_role!(id)
    render(conn, "show.html", user: user, roles: Accounts.list_roles)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user_with_role!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, roles: Accounts.list_roles)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user_with_role!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, roles: Accounts.list_roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
