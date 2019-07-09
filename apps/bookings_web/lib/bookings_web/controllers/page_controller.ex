defmodule BookingsWeb.PageController do
  use BookingsWeb, :controller

  def index(conn, _params) do
    bookings = Bookings.Booking.all()
    render(conn, "index.html", bookings: bookings)
  end
end
