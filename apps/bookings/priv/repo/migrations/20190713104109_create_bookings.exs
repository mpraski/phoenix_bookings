defmodule Bookings.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add(:person, :string)
      add(:from, :date)
      add(:to, :date)
      add(:place_id, references(:places), null: false)

      timestamps()
    end
  end
end
