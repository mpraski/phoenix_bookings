defmodule BookingsWeb.BookingView do
  use BookingsWeb, :view

  alias Bookings.Place
  
  def places_select(places \\ []) do
    places |> Enum.map(&{&1.name, &1.id})
  end
end
