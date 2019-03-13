defmodule MyApp.Guardian.AuthPipeline do
    use Guardian.Plug.Pipeline, otp_app: :my_app,
    module: MyApp.Guardian,
    error_handler: MyApp.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

