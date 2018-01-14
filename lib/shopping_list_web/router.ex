defmodule ShoppingListWeb.Router do
  use ShoppingListWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug ShoppingListWeb.Plugs.SetUser

  end

  pipeline :admin do
    plug :browser
    # plug ShoppingListWeb.Plugs.RequireAdmin

  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", ShoppingListWeb do
    pipe_through :admin

    get "/", UserController, :index
    resources "/users", UserController
    resources "/roles", RoleController
  end

  scope "/auth", ShoppingListWeb do
    pipe_through :browser

    get "/signout", AuthController, :signout

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end


  scope "/", ShoppingListWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ShoppingListWeb.Api do
    pipe_through :api
    resources "/users", UserController
  end
end
