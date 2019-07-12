defmodule Bookings.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:email, :string)
      add(:password_hashed, :string)

      timestamps()
    end

    create(unique_index(:users, [:username]))
  end
end
