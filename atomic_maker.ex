defmodule AtomicMaker do

  defmacro create_functions(atomic_list) do
    Enum.map atomic_list, fn {name, weight} ->
      quote do
        def unquote(name)() do
          unquote(weight)
        end
      end
    end
  end

end
