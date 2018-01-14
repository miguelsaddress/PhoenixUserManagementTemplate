defmodule ShoppingList.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false

      timestamps()
    end

    create table(:users) do
      add :name, :string
      add :email, :string, null: false
      add :google_token, :string, null: false
      add :image, :string
      add :role_id, references(:roles), default: 1, null: false

      timestamps()

    end

    create unique_index(:users, [:email])
    create unique_index(:roles, [:name])

  end
end
