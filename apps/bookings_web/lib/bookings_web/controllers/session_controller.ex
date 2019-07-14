defmodule BookingsWeb.SessionController do
  use BookingsWeb, :controller
  
  alias Bookings.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case User.get_by_username_and_password(username, password) do
      %User{} = user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Login successful")
        |> redirect(to: Routes.user_path(conn, :show, user))

      _ ->
        conn
        |> put_flash(:error, "Login failed")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> configure_session(drop: true)
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
