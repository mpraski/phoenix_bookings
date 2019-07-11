defmodule Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  import Bookings.Helpers

  @default_duration 7

  # Schema definition
  schema "bookings" do
    field(:place, :string)
    field(:person, :string)
    field(:from, :date)
    field(:to, :date)

    timestamps()
  end

  # Set dynamic default values
  schema_presets(
    from: Date.utc_today(),
    to: Date.utc_today() |> Date.add(@default_duration)
  )

  # Implement common Ecto methods 
  schema_api()

  # Define changeset validation
  schema_changeset [:place, :person, :from, :to] do
    validate_required([:place, :person, :from, :to])
    |> validate_length(:place, min: 5, max: 200)
    |> validate_format(:person, ~r/((\w)( \w)*)/)
    |> validate_change(:from, &validate_from/2)
    |> validate_duration
  end

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
