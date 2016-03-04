defmodule Calculus do
  def derivative(func, val) do
    delta = 1.0e-10
    (func.(val + delta) - func.(val)) / delta
  end
end
