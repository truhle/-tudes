defmodule Stats do
  def minimum(list) do
    try do
      [h|t] = list
      minimum(t, h)
    rescue
      error -> error
    end
  end

  def minimum([], lowest) do
    lowest
  end

  def minimum([h|t], lowest) do
    new_lowest = if (h < lowest), do: h, else: lowest
    minimum(t, new_lowest)
  end

  def maximum(list) do
    try do
      [h|t] = list
      maximum(t, h)
    rescue
      error -> error
    end
  end

  def maximum([], highest) do
    highest
  end

  def maximum([h|t], highest) do
    new_highest = if (h > highest), do: h, else: highest
    maximum(t, new_highest)
  end

  def range(list) do
    [minimum(list), maximum(list)]
  end

  def mean(list) do
    try do
      List.foldl(list, 0, &(&1 + &2)) / Enum.count(list)
    rescue
      error -> error
    end
  end

  def stdv(list) do
    try do
      n = Enum.count(list)
      {sum, sos} = List.foldl(list, {0, 0}, fn(v, {s1, s2}) ->
        {s1 + v, s2 + v * v}
      end)
      :math.sqrt((n * sos - sum * sum) / (n * (n - 1)))
    rescue
      error -> error
    end
  end
end
