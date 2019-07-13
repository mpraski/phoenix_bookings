defmodule Bookings.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bookings.Schema
  require Bookings.Password

  alias __MODULE__
  alias Bookings.Password

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hashed, :string)

    timestamps()
  end

  schema_api do
    changeset [:username, :email, :password] do
      validate_required(:password)
      validate_length(:password, min: 5)
      validate_confirmation(:password, required: true)
      hash_password()
      validate_required([:username, :email, :password_hashed])
      validate_length(:username, min: 3)
      unique_constraint(:username)
    end
  end

  def get_by_username_and_password(username, password) do
    with user when not is_nil(user) <- User.get_by(username: username),
         true <- Password.verify_with_hash(password, user.password_hashed) do
      user
    else
      _ -> Password.dummy_verify()
    end
  end

  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    changeset |> put_change(:password_hashed, Password.hash(password))
  end

  defp hash_password(changeset), do: changeset
end
