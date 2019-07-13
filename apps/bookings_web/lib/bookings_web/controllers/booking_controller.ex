defmodule BookingsWeb.BookingController do
  use BookingsWeb, :controller
  alias Bookings.Booking

  def index(conn, _params) do
    bookings = Booking.all_with_place()
    render(conn, "index.html", bookings: bookings)
  end

  def show(conn, %{"id" => id}) do
    booking = Booking.get_with_place(id)
    render(conn, "show.html", booking: booking)
  end

  def new(conn, _params) do
    booking = Booking.new()
    render(conn, "new.html", booking: booking)
  end

  def create(conn, %{"booking" => booking_params}) do
    case Booking.insert(booking_params) do
      {:ok, booking} -> redirect(conn, to: Routes.booking_path(conn, :show, booking))
      {:error, changeset} -> render(conn, "new.html", booking: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    booking = Booking.edit(id)
    render(conn, "edit.html", booking: booking)
  end

  def update(conn, %{"id" => id, "booking" => booking_params}) do
    booking = Booking.get(id)

    case Booking.update(booking, booking_params) do
      {:ok, booking} -> redirect(conn, to: Routes.booking_path(conn, :show, booking))
      {:error, changeset} -> render(conn, "edit.html", booking: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Booking.delete(id) do
      {:ok, _booking} -> redirect(conn, to: Routes.booking_path(conn, :index))
      {:error, changeset} -> redirect(conn, to: Routes.booking_path(conn, :show, changeset.data))
    end
  end
end
