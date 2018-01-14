defmodule ShoppingListWeb.Plugs.SetUser do
  import Plug.Conn

  alias ShoppingList.Accounts

  def init(_params) do
    # nothing
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    cond do
      user = user_id && Accounts.get_user_with_role!(user_id) ->
         assign(conn, :user, user)
      true ->
         assign(conn, :user, nil)
    end
  end
end
