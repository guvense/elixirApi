defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  plug Ueberauth

  alias MyApp.Auth
  alias MyApp.Auth.User
  alias MyApp.Guardian
  action_fallback MyAppWeb.FallbackController

    @doc """
    sign_in
    conn ve map in içinde username ve password parametrelerini alıcak
    with ile
    MyApp.Auth.auth_user(username,password) fonsiyonu çağrılacak beklenen  {:ok, user}
    Guardian.encode_and_sign(%User{username: username, password: password}) beklenen {:ok, token, _claims}
    pattern matching de sorun çıkmazsa status ok dönecek ve MyAppWeb.UserView içindeki "sign_in.json" çağrılacak
                        sorun çıkarsa unauthorized 401 dönecek

     sign_up
    sign_in gibi sadece MyApp.Auth.create_user çağrılacak
  """


  def sign_in(conn, %{"username" => username, "password" => password }) do
    with {:ok, %User{} = user} <- MyApp.Auth.auth_user(username,password),
         {:ok, token, _claims} = Guardian.encode_and_sign(user) do
        conn
        |> put_status(:ok)
        |> render(MyAppWeb.UserView, "sign_in.json",user: user, jwt: token)
        else
        {:error, message} ->
          conn

          |> put_status(:unauthorized)
          |>render(MyAppWeb.ErrorView,"401.json",message: message)

        end
      end

    def sign_up(conn, %{"username" => username, "password" => password }) do
      with {:ok, user} <- MyApp.Auth.create_user(%{"username" => username, "password" => password }),
           {:ok, token, _claims} = Guardian.encode_and_sign(%User{username: username, password: password}) do
            conn
            |> put_status(:ok)
            |> render(MyAppWeb.UserView, "sign_in.json",user: user, jwt: token)
            else
            {:error, message} ->
              conn
              |> put_status(:unauthorized)
              |>render(MyAppWeb.ErrorView,"401.json",message: message)

            end
          end





  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
