defmodule BookingsWeb.PlaceController do
  use BookingsWeb, :controller
  use BookingsWeb.Authorizer
  
  alias Bookings.Place

  def index(conn, _params) do
    places = Place.all()
    render(conn, "index.html", places: places)
  end

  def show(conn, %{"id" => id}) do
    place = Place.get(id)
    render(conn, "show.html", place: place)
  end

  def new(conn, _params) do
    place = Place.new()
    render(conn, "new.html", place: place)
  end

  def create(conn, %{"place" => place_params}) do
    case Place.insert(place_params) do
      {:ok, place} -> redirect(conn, to: Routes.place_path(conn, :show, place))
      {:error, changeset} -> render(conn, "new.html", place: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    place = Place.edit(id)
    render(conn, "edit.html", place: place)
  end

  def update(conn, %{"id" => id, "place" => place_params}) do
    place = Place.get(id)

    case Place.update(place, place_params) do
      {:ok, place} -> redirect(conn, to: Routes.place_path(conn, :show, place))
      {:error, changeset} -> render(conn, "edit.html", place: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Place.delete(id) do
      {:ok, _place} -> redirect(conn, to: Routes.place_path(conn, :index))
      {:error, changeset} -> redirect(conn, to: Routes.place_path(conn, :show, changeset.data))
    end
  end
end