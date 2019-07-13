defmodule Bookings.Medium do
  use Ecto.Schema
  import Ecto.Changeset
  import Bookings.Schema
  require UUID

  @media_path "/media"

  schema "media" do
    field(:name, :string)
    field(:file, :string)
    field(:type, :string)

    belongs_to(:place, Bookings.Place)
  end

  schema_api do
    changeset [:name, :file, :type, :place_id] do
      validate_required([:name, :file, :type, :place_id])
      validate_length(:name, min: 5)
      unique_constraint(:name)
      assoc_constraint(:place)
      validate_file()
    end
  end

  defp validate_file(changeset) do
    if changeset.valid? do
      name = changeset |> get_field(:name)
      file = changeset |> get_field(:file)
      extension = Path.extname(file)

      with new_file <- media_file_name(name, extension),
           :ok <- File.cp(file, media_file_path(new_file)) do
        changeset |> put_change(:file, new_file)
      else
        _ -> changeset |> add_error(:file, "Could not move temporary file to media directory")
      end
    else
      changeset
    end
  end

  defp media_file_name(name, extension) do
    "#{Base.encode64(name)}-#{UUID.uuid1()}#{extension}"
  end

  defp media_file_path(file) do
    Path.join([@media_path, file])
  end
end
