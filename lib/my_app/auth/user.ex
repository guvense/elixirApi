defmodule MyApp.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :username, :string
    field :password, :string, virtual: true # password database de yer tutmaması için virtual yapıldı
    field :password_hash, :string
    has_many(:images, MyApp.Images.Image) # images user a bağlandı


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> pass_hash()
  end
  @doc """
  pass_hash

  1-) Changeset model değişliklerinde kullanılır
  2-) Change fonksiyonu verilen modeli değiştirmek için changeset oluşturur
  3-) defp ile bu fonksiyonlar gizli tutulur

  """

  defp pass_hash (
      %Ecto.Changeset{valid?: true, changes: %{password: password}}= changeset
  )do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))

  end

  defp pass_hash(changeset) do
    changeset
  end

end
