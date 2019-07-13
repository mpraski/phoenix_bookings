defmodule Bookings.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:media) do
      add(:name, :string, null: false)
      add(:file, :string, null: false)
      add(:type, :string, null: false)
      add(:place_id, references(:places), null: false)

      timestamps()
    end
  end
end
