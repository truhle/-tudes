defmodule Dijkstra do
  def cond_gcd(m, n) do
    cond do
      m == n -> m
      m > n -> cond_gcd(m - n, n)
      m < n -> cond_gcd(m, n - m)
    end
  end

  def guard_gcd(m, n) when m == n do
    m
  end

  def guard_gcd(m, n) when m > n do
    guard_gcd(m - n, n)
  end

  def guard_gcd(m, n) when m < n do
    guard_gcd(m, n - m)
  end
end
