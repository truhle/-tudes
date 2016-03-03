defmodule NonFP do
  def generate_pockets(list_of_teeth, prob_good) do
    generate_pockets(list_of_teeth, prob_good, [])
  end

  def generate_pockets([], _prob_good, result) do
    Enum.reverse(result)
  end

  def generate_pockets([h|t], prob_good, result) do
    case h do
      70 -> generate_pockets(t, prob_good, [[0] | result])
      84 -> generate_pockets(t, prob_good, [generate_tooth(prob_good) | result])
    end
  end

  def generate_tooth(prob_good) do
    :random.seed({:erlang.monotonic_time, :erlang.time_offset, :erlang.unique_integer})
    good = :random.uniform <= prob_good
    base_depth = if (good), do: 2, else: 3
    generate_tooth(base_depth, 6, [])
  end

  def generate_tooth(_base_depth, 0, depths) do
    depths
  end

  def generate_tooth(base_depth, num, depths) do
    variation = 2 - :random.uniform(3)
    depth = base_depth + variation
    generate_tooth(base_depth, num - 1, [depth | depths])
  end
end
