defmodule Bookings.Helpers do
  defmacro schema_api(module \\ __CALLER__.module, repo \\ quote(do: Bookings.Repo)) do
    quote do
      def new, do: create() |> changeset

      def insert(attrs \\ %{}) do
        create()
        |> changeset(attrs)
        |> unquote(repo).insert()
      end

      def delete(%unquote(module){} = model), do: unquote(repo).delete(model)

      def delete(id) when is_number(id), do: get(id) |> unquote(repo).delete

      def update(%unquote(module){} = model, updates \\ %{}) do
        model
        |> changeset(updates)
        |> unquote(repo).update()
      end

      def edit(id) when is_number(id), do: get(id) |> changeset

      def all(), do: unquote(repo).all(unquote(module))

      def get_by(attrs \\ []), do: unquote(repo).get_by(unquote(module), attrs)

      def one(attrs \\ []), do: unquote(repo).one(unquote(module), attrs)

      def get(id) when is_number(id), do: unquote(repo).get(unquote(module), id)
    end
  end

  # Used to set dynamic default values for model fields (like date or datetime)
  defmacro schema_presets(options \\ [], module \\ __CALLER__.module) do
    options_functors =
      options
      |> Enum.map(fn {k, v} -> {k, quote(do: fn -> unquote(v) end)} end)

    quote do
      defp create do
        %unquote(module){}
        |> struct(
          unquote(options_functors)
          |> Enum.map(fn {k, v} -> {k, v.()} end)
        )
      end
    end
  end

  defmacro schema_changeset(fields \\ [], module \\ __CALLER__.module, do: expr) do
    quote do
      defp changeset(%unquote(module){} = var!(model), var!(attrs) \\ %{}) do
        var!(model)
        |> cast(var!(attrs), unquote(fields))
        |> unquote(expr)
      end
    end
  end
end
