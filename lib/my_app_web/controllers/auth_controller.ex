defmodule MyAppWeb.AuthController do
  use MyAppWeb, :controller

  alias MyApp.Accounts

  plug Ueberauth

  # def callback(%{assigns: %{ueberauth_auth: %{info: %{email: email, image: image}, credentials: %{token: token}}}} = conn, _params) do
  #   IO.inspect(conn.assigns.ueberauth_auth)
  # end

  def callback(%{assigns: %{ueberauth_auth: %{info: %{email: email, image: image, name: name}, credentials: %{token: token}}}} = conn, _params) do
    user_params = %{email: email, google_token: token, image: image, name: name, role_id: 2}
    changeset = Accounts.user_changeset(user_params)

    signin(conn, changeset)
  end

  defp insert_or_update_user(changeset) do
    should_signup = Application.get_env(:my_app, :signup_enabled)
    case Accounts.get_user_by_email(changeset.changes.email) do
      nil   -> if should_signup do
        Accounts.create_user_with_role(changeset.changes)
      else
        {:error, :signup_disabled}
      end
      user  -> {:ok, user}
    end
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Authenticated as [#{user.email}].")
        |> redirect(to: user_path(conn, :index))
      {:error, :signup_disabled} ->
        conn
        |> put_flash(:error, "User is not a member and sign in is disabled.")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "User could not be authenticated.")
        |> redirect(to: user_path(conn, :index))
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "See you soon")
    |> redirect(to: page_path(conn, :index))
  end
end
