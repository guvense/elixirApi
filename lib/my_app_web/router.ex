defmodule MyAppWeb.Router do
  use MyAppWeb, :router


    @doc """

    İki adet pipeline var api ve api_auth

    api' ye session' ı bağlanıyor
    api_auth ta ise ensure_authenticated fonskiyonu bağlanıyor
    sign_in api pipeline ı kullandığı için auth olmasına gerek yok

    check_user_auth ise id alarak session dan id dönüyor  current_user_id
    current_user_id nil ise 403 dönecek
    halt(conn) ile pipeline durdurulur

    /users/sign_in end point'i eklendi UserController daki sign_in metodu bağlandı

  """
  alias MyApp.Guardian
  alias MyApp.Guardian.AuthPipeline


  pipeline :api do
    plug :accepts, ["json"]

  end

  #Auth gereken end poitler için
  pipeline :jwt_authenticated do
    plug  Guardian.AuthPipeline
  end

  # giriş username pass
  scope "/api", MyAppWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post "/users/sign_in", UserController, :sign_in
  end

  #kayıt username pass
  scope "/api", MyAppWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post "/users/sign_up", UserController, :sign_up
  end

  #crop base64 x_dim ve y_dim
  scope "/api", MyAppWeb do
    pipe_through [:api,:jwt_authenticated]

    post "/image/crop", ImageController, :crop
  end

  #resize base64 x_dim ve y_dim
  scope "/api", MyAppWeb do
    pipe_through [:api,:jwt_authenticated]

    post "/image/resize", ImageController, :resize
  end

  #filter base64 filter_option 0,1
  scope "/api", MyAppWeb do
    pipe_through [:api,:jwt_authenticated]

    post "/image/filter", ImageController, :filter
  end

end
