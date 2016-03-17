defmodule Duration do

  defmacro add({h1, m1}, {h2, m2}) do
    quote do
      total_h = unquote(h1) + unquote(h2)
      total_m = unquote(m1) + unquote(m2)
      cond do
        total_m < 60 -> {total_h, total_m}
        true -> {total_h + 1, total_m - 60}
      end
    end
  end

  defmacro {h1, m1} + {h2, m2} do
    quote do
      total_h = unquote(h1) + unquote(h2)
      total_m = unquote(m1) + unquote(m2)
      cond do
        total_m < 60 -> {total_h, total_m}
        true -> {total_h + 1, total_m - 60}
      end
    end
  end

  defmacro a + b do
    quote do
      unquote(a) + unquote(b)
    end
  end
end
