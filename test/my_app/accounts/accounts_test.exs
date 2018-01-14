defmodule MyApp.AccountsTest do
  use MyApp.DataCase

  alias MyApp.Accounts

  describe "users" do
    alias MyApp.Accounts.User

    @valid_attrs %{email: "some.email@example.org", google_token: "some google_token", name: "some name", role_id: 1}
    @update_attrs %{email: "some.updated.email@example.org", google_token: "some updated google_token", name: "some updated name", role_id: 2}
    @invalid_attrs %{email: nil, google_token: nil, name: nil, role: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, _role_admin} = Accounts.create_role(%{id: 1, name: "Admin"})
      {:ok, _role_user} = Accounts.create_role(%{id: 2, name: "User"})

      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_with_role()

      user
    end

    def admin_role_fixture do
      {:ok, role_admin} = Accounts.create_role(%{id: 1, name: "Admin"})
      role_admin
    end

    def user_role_fixture do
      {:ok, role} = Accounts.create_role(%{id: 2, name: "User Role"})
      role
    end

    test "list_users/0 returns all users" do
      user = user_fixture() |> Accounts.load_role_for_user
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      _role = admin_role_fixture()

      assert {:ok, %User{} = user} = Accounts.create_user_with_role(@valid_attrs)
      assert user.email == "some.email@example.org"
      assert user.google_token == "some google_token"
      assert user.name == "some name"
      assert user.role_id == 1
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      _role = user_role_fixture()
      _role = admin_role_fixture()
      {:ok, user} = Accounts.create_user(@valid_attrs)

      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some.updated.email@example.org"
      assert user.google_token == "some updated google_token"
      assert user.name == "some updated name"
      # assert user.role_id == 2
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "roles" do
    alias MyApp.Accounts.Role

    @valid_attrs %{id: 1, name: "Admin"}
    @update_attrs %{id: 2, name: "User"}
    @invalid_attrs %{name: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Accounts.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Accounts.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = _role} = Accounts.create_role(@valid_attrs)
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, role} = Accounts.update_role(role, @update_attrs)
      assert %Role{} = role
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_role(role, @invalid_attrs)
      assert role == Accounts.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Accounts.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Accounts.change_role(role)
    end
  end
end
