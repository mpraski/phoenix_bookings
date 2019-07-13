defmodule BookingsWeb.Router do
  use BookingsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BookingsWeb.Plugs.Authenticator
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BookingsWeb do
    pipe_through :browser

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    resources "/", BookingController
    resources "/users", UserController
    resources "/places", PlaceController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookingsWeb do
  #   pipe_through :api
  # end
end
