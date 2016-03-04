defmodule Cards do
  @moduledoc """
  Functions for simulating a deck of cards
  """
  @vsn 0.1

  @suits ~w(Clubs Diamonds Heart Spades)
  @values ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"]


  @doc """
  Create a deck of 52 tuples in the form[{"A", "Clubs"},
  {"A", "Diamonds"}...]
  """
  @spec make_deck() :: list(tuple)

  def make_deck do
    for v <- @values, s <- @suits, do: {v,s}
  end

  @doc """
    Seeds the random number generator and calls shuffle/2 with
    a list of cards and an empty list to serve as the accumulator.
    Returns a list of shuffled card tuples.
  """
  @spec shuffle(list) :: list

  def shuffle(list) do
    :random.seed({:erlang.monotonic_time,
                  :erlang.time_offset,
                  :erlang.unique_integer})
    shuffle(list, [])
  end

  @doc """
    Returns a list randomized by splitting a source list of
    cards at a random location and adding the head of the second
    list to an accumlator.  Recursively calls itself until the
    source list is empty.
  """
  @spec shuffle(list, list) :: list

  def shuffle([], acc) do
    acc
  end

  def shuffle(list, acc) do
    num_cards = Enum.count(list) - 1
    split_loc = if (num_cards > 0),
      do: :random.uniform(num_cards),
    else: 0
    {leading, [h | t]} =
      Enum.split(list, split_loc)
    shuffle(t ++ leading, [h | acc])
  end
end
