defmodule Bookings.Place do
  use Ecto.Schema
  import Ecto.Changeset
  import Bookings.Schema

  alias Bookings.Booking

  schema "places" do
    field(:name, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:address_one, :string)
    field(:address_two, :string)
    field(:address_three, :string)
    field(:details, :string)

    has_many(:media, Bookings.Medium)
    has_many(:bookings, Bookings.Booking)

    timestamps()
  end

  # TO-DO: Don't delete as long as there exists a booking which relies on this place
  schema_api do
    changeset [:name, :latitude, :longitude, :address_one, :address_two, :address_three, :details] do
      validate_required([:name, :latitude, :longitude, :address_one])
      validate_length(:name, min: 5)
      unique_constraint(:name)
    end
  end

  schema_preload :media
  schema_preload :bookings
end
