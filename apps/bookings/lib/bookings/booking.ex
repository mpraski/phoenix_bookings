defmodule Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  import Bookings.Helpers

  @duration 7

  alias Bookings.Repo

  # Schema definition
  schema "bookings" do
    field(:person, :string)
    field(:from, :date)
    field(:to, :date)

    belongs_to(:place, Bookings.Place)

    timestamps()
  end

  # Macro defining common model functions, dynamic default values (presets) 
  # and changeset function
  schema_api do
    preset(:from, Date.utc_today())
    preset(:to, Date.utc_today() |> Date.add(@duration))

    changeset [:person, :from, :to, :place_id] do
      validate_required([:person, :from, :to, :place_id])
      validate_format(:person, ~r/((\w)( \w)*)/)
      validate_change(:from, &validate_from/2)
      validate_duration
      assoc_constraint(:place)
    end
  end
  
  schema_preload :place

  # Private API
  defp validate_from(:from, from) do
    case Date.compare(from, Date.utc_today()) do
      :lt -> [from: "Cannot be in the past"]
      _ -> []
    end
  end

  defp validate_duration(changeset) do
    from = changeset |> get_field(:from)
    to = changeset |> get_field(:to)

    case Date.compare(from, to) do
      :gt -> changeset |> add_error(:from, "Duration cannot be negative")
      _ -> changeset
    end
  end
end
