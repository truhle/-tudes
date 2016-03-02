defmodule Powers do

  import Kernel, except: [raise: 2, raise: 3]

  def raise(x, n) do
    cond do
      n == 0 -> 1
      n == 1 -> x
      n > 0 -> raise(x, n, 1)
      n < 0 -> 1.0 / raise(x, -n)
    end
  end

  defp raise(x, n, acc) when n > 0 do
    new_acc = acc * x
    raise(x, n - 1, new_acc)
  end

  defp raise(x, n, acc) do
    acc
  end

  def nth_root(x, n) do
    nth_root(x, n, x / 2.0)
  end

  defp nth_root(x, n, a) do
    f = raise(a, n) - x
    f_prime = n * raise(a, n - 1)
    next = a - f / f_prime
    IO.puts("Current guess is #{a}")
    change = abs(next - a)
    cond do
      change < 1.0e-8 -> next
      true -> nth_root(x, n, next)
    end
  end
end
