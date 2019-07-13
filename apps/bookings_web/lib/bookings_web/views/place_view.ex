defmodule BookingsWeb.PlaceView do
  use BookingsWeb, :view

  alias Bookings.Place

  def address(%Place{address_one: a1, address_two: a2, address_three: a3}) do
    [a1, a2, a3]
    |> Enum.reject(&is_nil/1)
    |> Enum.intersperse(", ")
  end
end
