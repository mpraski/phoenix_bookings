defmodule BookingsWeb.Authenticator do
  import Plug.Conn

  alias Bookings.User

  def init(opts \\ []), do: opts

  def call(conn, _opts) do
    user =
      conn
      |> get_session(:user_id)
      |> case do
        nil -> nil
        id -> User.get(id)
      end

    assign(conn, :current_user, user)
  end
end
