defmodule BookingsWeb.Authorizer do
  import Plug.Conn
  import Phoenix.Controller

  alias Plug.Conn
  alias BookingsWeb.Router.Helpers, as: Routes

  defmacro __using__(opts \\ [])

  defmacro __using__([]) do
    quote do
      import BookingsWeb.Authorizer, only: [required_logged_in: 2]
      plug :required_logged_in
    end
  end

  defmacro __using__(routes) do
    quote do
      import BookingsWeb.Authorizer, only: [required_logged_in: 2]
      plug :required_logged_in when quote(do: action) in unquote(routes)
    end
  end

  def required_logged_in(%Conn{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "Please log in to see this resource.")
    |> redirect(to: login_route(conn))
    |> halt()
  end

  def required_logged_in(conn, _opts), do: conn

  defp login_route(conn), do: Routes.session_path(conn, :new)
end
