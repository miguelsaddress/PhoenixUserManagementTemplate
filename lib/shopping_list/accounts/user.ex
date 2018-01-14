defmodule ShoppingList.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ShoppingList.Accounts.User
  alias ShoppingList.Accounts.Role

  schema "users" do
    field :email, :string
    field :google_token, :string
    field :image, :string
    field :name, :string

    timestamps()

    belongs_to :role, Role
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :google_token, :role_id])
    |> validate_required([:email, :google_token, :role_id])
    |> foreign_key_constraint(:role_id)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)

  end
end
