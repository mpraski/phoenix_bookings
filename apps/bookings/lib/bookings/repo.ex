defmodule Bookings.Repo do
  use Ecto.Repo,
    otp_app: :bookings,
    adapter: Ecto.Adapters.Postgres
end
