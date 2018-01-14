defmodule ShoppingList.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias ShoppingList.Accounts.Role
  alias ShoppingList.Accounts.User


  schema "roles" do
    field :name, :string

    timestamps()

    has_many :users, User
  end

  @doc false
  def changeset(%Role{} = role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
  
end
