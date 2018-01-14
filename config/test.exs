use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shopping_list, ShoppingListWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :debug

# Configure your database
config :shopping_list, ShoppingList.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "shopping_list_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# If during signup the user does not exist, create it
config :shopping_list, :signup_enabled, true
