defmodule ShoppingListWeb.UserView do
  use ShoppingListWeb, :view

  def roles_select_value_list(roles) do
    roles |> Enum.map(fn(role) -> {role.name, role.id} end)
  end
end
