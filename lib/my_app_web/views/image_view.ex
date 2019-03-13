defmodule MyAppWeb.ImageView do
  use MyAppWeb, :view
  alias MyAppWeb.UserView


  def render("image.json", %{user_id: user_id, path: path}) do
    %{
      data: %{
        user_id: user_id,
        path: path
      }
    }
    end

end
