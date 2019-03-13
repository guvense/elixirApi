defmodule MyAppWeb.ImageController do
    use MyAppWeb, :controller

    alias MyApp.Guardian
    alias MyApp.Images
    alias MyApp.Images.Image
    alias MyApp.Auth
    alias MyApp.Repo
    alias MyAppWeb.UserView
    alias MyAppWeb.ImageView
    alias MyAppWeb.ErrorView
    action_fallback MyAppWeb.FallbackController

     @doc """
    Crop ve Resize
    base64 x_dim ve y_dim alır
    base64 decode edilir cropped dosyası oluşturulur.
    uuid ile id generate edilir
    guardian ile conn kullanarak user bulunur ve repodan çekilir
    ecto ile association kurulup repoya insert edilir

    """

    def crop(conn, %{"base64" => base64, "x_dim"=> x_dim, "y_dim"=>y_dim }) do

        {:ok, image_binary} = Base.decode64(base64)
        File.mkdir_p("cropped/")
        image_path="cropped/#{Ecto.UUID.generate}.jpg"
        File.write!(image_path, image_binary, [:write])
        user_login = Guardian.Plug.current_resource(conn)
        user=MyApp.Auth.get_user!(user_login.id)
        Repo.insert(Ecto.build_assoc(user,:images, path: image_path))
        conn
        |>
        render(MyAppWeb.ImageView,"image.json",user_id:  user_login.id, path: image_path)

    end

    def resize(conn, %{"base64" => base64, "x_dim"=> x_dim, "y_dim"=>y_dim }) do
        {:ok, image_binary} = Base.decode64(base64)
        File.mkdir_p("resize/")
        image_path="resize/#{Ecto.UUID.generate}.jpg"
        File.write!(image_path, image_binary, [:write])
        user_login = Guardian.Plug.current_resource(conn)
        user=MyApp.Auth.get_user!(user_login.id)
        Repo.insert(Ecto.build_assoc(user,:images, path: image_path))
        conn
        |>
        render(MyAppWeb.ImageView,"image.json",user_id:  user_login.id, path: image_path)

    end


    @doc """
    Filter
    base64 filter option alınır 0,1
    base64 decode edilir cropped dosyası oluşturulur.
    filter option int e convert edilir ve case içinde uygun path yazılır
    0,1 dışında ise error 401 dönülür

    rend çağrılır ve yukarıdaki fonskiyolarda olduğu gibi ilerler

    """

    def filter(conn, %{"base64" => base64, "filter_option"=> filter_option }) do

        {:ok, image_binary} = Base.decode64(base64)

        {intVal, ""}=Integer.parse(filter_option)
        case intVal   do
            0 -> File.mkdir_p("filtered0/")
                 image_path="filtered0/#{Ecto.UUID.generate}.jpg"
                 rend(conn,filter_option,image_path,image_binary)

            1 -> File.mkdir_p("filtered1/")
                 image_path="filtered1/#{Ecto.UUID.generate}.jpg"
                 rend(conn,filter_option,image_path,image_binary)

            _ -> render(conn,MyAppWeb.ErrorView,"401.json",message: "invalid filter_option")

        end

    end

    def rend(conn,filter_option,image_path,image_binary) do
        File.write!(image_path, image_binary, [:write])
        user_login = Guardian.Plug.current_resource(conn)
        user=MyApp.Auth.get_user!(user_login.id)
        Repo.insert(Ecto.build_assoc(user,:images, path: image_path))
        conn
        |>
        render(MyAppWeb.ImageView,"image.json",user_id:  user_login.id, path: image_path)
    end

  end
