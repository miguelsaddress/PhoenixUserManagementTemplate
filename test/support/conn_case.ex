defmodule ShoppingListWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import ShoppingListWeb.Router.Helpers
      # The default endpoint for testing
      @endpoint ShoppingListWeb.Endpoint

      def sign_in_admin(conn) do
        alias ShoppingList.Accounts
        alias ShoppingList.Accounts.User
        alias ShoppingList.Accounts.Role
        role = %Role{id: 1, name: "Admin"}
        {:ok, role} = Accounts.create_role(role)
        user = %User{email: "email@example.org", google_token: "some google_token", name: "some name", role_id: 1}
        {:ok, user} = Accounts.create_user_with_role(user)
        conn = assign(conn, :user, user)
        require Logger
        Logger.debug "debugging #{inspect conn}"



        conn
        |> bypass_through(ShoppingListWeb.Router, :admin)
        |> get("/")
        |> put_session(:user_id, user.id)
        |> send_resp(:ok, "")
        |> recycle()

      end
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ShoppingList.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ShoppingList.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end
