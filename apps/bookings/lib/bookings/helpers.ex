defmodule Bookings.Helpers do
  defmacro model_api(module \\ __CALLER__.module, repo \\ quote(do: Bookings.Repo)) do
    quote do
      def insert(attrs \\ []) do
        %unquote(module){}
        |> changeset(Map.new(attrs))
        |> unquote(repo).insert()
      end

      def delete(%unquote(module){} = mod), do: unquote(repo).delete(mod)

      def update(%unquote(module){} = mod, updates \\ []) do
        mod
        |> changeset(Map.new(updates))
        |> unquote(repo).update()
      end

      def all(), do: unquote(repo).all(unquote(module))

      def get_by(attrs \\ []), do: unquote(repo).get_by(unquote(module), attrs)

      def one(attrs \\ []), do: unquote(repo).one(unquote(module), attrs)

      def get(id), do: unquote(repo).get(unquote(module), id)
    end
  end

  defmacro model_changeset(fields \\ [], module \\ __CALLER__.module, do: expr) do
    quote do
      defp changeset(%unquote(module){} = var!(model), var!(attrs)) do
        var!(model)
        |> cast(var!(attrs), unquote(fields))
        |> unquote(expr)
      end
    end
  end
end
