use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :my_app, MyAppWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
config :bcrypt_elixir, :log_rounds, 4

# Configure your database
config :my_app, MyApp.Repo,
  username: "postgres",
  password: "1224",
  database: "buybuddy",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
