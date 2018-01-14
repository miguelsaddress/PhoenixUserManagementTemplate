defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug MyAppWeb.Plugs.SetUser

  end

  pipeline :admin do
    plug :browser
    # plug MyAppWeb.Plugs.RequireAdmin

  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", MyAppWeb do
    pipe_through :admin

    get "/", UserController, :index
    resources "/users", UserController
    resources "/roles", RoleController
  end

  scope "/auth", MyAppWeb do
    pipe_through :browser

    get "/signout", AuthController, :signout

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end


  scope "/", MyAppWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", MyAppWeb.Api do
    pipe_through :api
    resources "/users", UserController
  end
end
