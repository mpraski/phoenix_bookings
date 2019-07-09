defmodule Bookings.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table("bookings") do
      add :place, :string
      add :person, :string
      add :from, :date
      add :to, :date

      timestamps()
    end
  end
end
