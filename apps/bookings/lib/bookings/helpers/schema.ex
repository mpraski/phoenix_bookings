defmodule Bookings.Schema do
  defp build_presets(exprs, acc \\ [])

  defp build_presets([{:preset, _, [field, arg]} | rest], acc) do
    build_presets(rest, [{field, quote(do: fn -> unquote(arg) end)} | acc])
  end

  defp build_presets([_ | rest], acc) do
    build_presets(rest, acc)
  end

  defp build_presets([], acc), do: acc

  defp elixir_context, do: [context: Elixir, import: Kernel]

  defp build_pipeline(exprs, acc \\ {})

  defp build_pipeline([a | [b | exprs]], _acc) do
    build_pipeline_(exprs, {:|>, elixir_context(), [a, b]})
  end

  defp build_pipeline([a | []], _acc), do: a

  defp build_pipeline_([a | exprs], acc) do
    build_pipeline_(exprs, {:|>, elixir_context(), [acc, a]})
  end

  defp build_pipeline_([], acc), do: acc

  defmacro schema_api_(module, repo, fields, pipeline) do
    quote do
      defp changeset(%unquote(module){} = var!(model), var!(attrs) \\ %{}) do
        var!(model)
        |> cast(var!(attrs), unquote(fields))
        |> unquote(pipeline)
      end

      def new, do: create() |> changeset

      def insert(attrs \\ %{}) do
        create()
        |> changeset(attrs)
        |> unquote(repo).insert()
      end

      def delete(%unquote(module){} = model), do: unquote(repo).delete(model)

      def delete(id), do: get(id) |> unquote(repo).delete

      def update(%unquote(module){} = model, updates \\ %{}) do
        model
        |> changeset(updates)
        |> unquote(repo).update()
      end

      def edit(id), do: get(id) |> changeset

      def all(), do: unquote(repo).all(unquote(module))

      def get_by(attrs \\ []), do: unquote(repo).get_by(unquote(module), attrs)

      def one(attrs \\ []), do: unquote(repo).one(unquote(module), attrs)

      def get(id), do: unquote(repo).get(unquote(module), id)
    end
  end

  defmacro schema_api(module \\ __CALLER__.module, repo \\ quote(do: Bookings.Repo), expr)

  defmacro schema_api(module, repo,
             do:
               {:changeset, _,
                [
                  fields,
                  [do: {_, _, pipeline_expr}]
                ]}
           ) do
    pipeline = build_pipeline(pipeline_expr)

    quote do
      defp create do
        %unquote(module){}
      end

      schema_api_(
        unquote(module),
        unquote(repo),
        unquote(fields),
        unquote(pipeline)
      )
    end
  end

  defmacro schema_api(module, repo, do: {_, _, stmts}) do
    presets = build_presets(stmts)
    changeset = stmts |> Enum.find(fn {k, _, _} -> k == :changeset end)

    {_, _,
     [
       fields,
       [do: {_, _, pipeline_expr}]
     ]} = changeset

    pipeline = build_pipeline(pipeline_expr)

    quote do
      defp create do
        %unquote(module){}
        |> struct(
          unquote(presets)
          |> Enum.map(fn {k, v} -> {k, v.()} end)
        )
      end

      schema_api_(
        unquote(module),
        unquote(repo),
        unquote(fields),
        unquote(pipeline)
      )
    end
  end

  defmacro schema_preload(assoc, module \\ __CALLER__.module, repo \\ quote(do: Bookings.Repo))
           when is_atom(assoc) do
    quote do
      def unquote(:"get_with_#{assoc}")(id) do
        unquote(repo).get(unquote(module), id)
        |> unquote(repo).preload(unquote(assoc))
      end

      def unquote(:"all_with_#{assoc}")() do
        unquote(repo).all(unquote(module))
        |> unquote(repo).preload(unquote(assoc))
      end
    end
  end
end
