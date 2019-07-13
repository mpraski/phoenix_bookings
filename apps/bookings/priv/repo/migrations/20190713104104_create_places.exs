defmodule Bookings.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add(:name, :string, null: false)
      add(:latitude, :float, null: false)
      add(:longitude, :float, null: false)
      add(:address_one, :string, null: false)
      add(:address_two, :string)
      add(:address_three, :string)
      add(:details, :string)

      timestamps()
    end

    create(unique_index(:places, [:name]))
  end
end
