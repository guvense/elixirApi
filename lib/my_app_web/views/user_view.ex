defmodule MyAppWeb.UserView do
  use MyAppWeb, :view
  alias MyAppWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user }) do
    %{id: user.id,
      username: user.username
      }
  end

  def render("d.json", %{d: d}) do
    %{d: d}
  end

   @doc """
    sign_in.json

    controller dan çağrılacak ve map user ve jwt parametresi yollanacak
    ve içiçe geçmiş maplerden json dönecek

  """

  def render("sign_in.json", %{user: user,jwt: jwt}) do
  %{
    data: %{
      user: %{
        id: user.id,
        username: user.username,
        jwt: jwt
      }
    }
  }
  end


end
