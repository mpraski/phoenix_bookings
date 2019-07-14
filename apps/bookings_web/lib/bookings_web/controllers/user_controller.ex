defmodule BookingsWeb.UserController do
  use BookingsWeb, :controller
  use BookingsWeb.Authorizer, [:show]

  alias Bookings.User

  plug :authenticate when action in [:show]

  def show(conn, %{"id" => id}) do
    user = User.get(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    user = User.new
    render(conn, "new.html", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    case User.insert(user_params) do
      {:ok, user} -> redirect(conn, to: Routes.user_path(conn, :show, user))
      {:error, changeset} -> render(conn, "new.html", user: changeset)
    end
  end

  defp authenticate(conn, _opts) do
    current_user = conn.assigns |> Map.get(:current_user)

    requested_user_id =
      conn.params
      |> Map.get("id")
      |> String.to_integer()

    if current_user == nil || current_user.id != requested_user_id do
      conn
      |> put_flash(:error, "Can't see this user")
      |> redirect(to: Routes.booking_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end