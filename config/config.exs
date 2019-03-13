# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_app,
  ecto_repos: [MyApp.Repo]

config :my_app, MyApp.Guardian,
  issuer: "my_app",
  secret_key: "DquLMNUex4WPPPtRGoV/efSSBAThd7uiM00lj7i0IkR9kFnDq/6f1EBwNqZe7UeW",
  verify_module: Guardian.JWT


config :my_app, MyApp.Guardian.AuthPipeline,
  module: MyApp.Guardian,
  error_handler: MyApp.AuthErrorHandler

# Configures the endpoint
config :my_app, MyAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SltqySvGiEeebIDBtNTRRYUoaD86jLknMZwvdCYZHdCaj/H68Z9C6rblkH3/B1pO",
  render_errors: [view: MyAppWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: MyApp.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    facebook: { Ueberauth.Strategy.Facebook, [ opt1: "value", opts2: "value" ] },
    github: { Ueberauth.Strategy.Github, [ opt1: "value", opts2: "value" ] }
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
