defmodule Game do
  def play_war do
    {hand1, hand2} = Cards.make_deck |> Cards.shuffle |> Enum.split(26)
    p1 = spawn_link(Player, :player, [self(), hand1])
    p2 = spawn_link(Player, :player, [self(), hand2])
    IO.puts("Game of war started between #{inspect p1} and #{inspect p2}")
    play_round([], 0, p1, p2, [])
  end

  def play_round(card_stack, count, p1, p2, empty_pids) do
    case card_stack do
      [] ->
        Enum.each([p1, p2], fn(pid) -> send(pid, :request_1) end)
      [_tuple] -> nil
      [tuple1, tuple2] ->
        result = eval_cards(tuple1, tuple2)
        case result do
          :tie ->
            Enum.each([p1, p2], fn(pid) -> send(pid, :request_3) end)
          {pid, cards} ->
            send(pid, cards)
            play_round([], 0, p1, p2, empty_pids)
        end
    end
    receive do
      {pid, []} ->
        case count do
          0 ->
            play_round(card_stack, 1, p1, p2, [pid | empty_pids])
          1 ->
            new_empty_pids = if (pid != List.first(empty_pids)),
                do: [pid | empty_pids],
              else: empty_pids
            end_game(new_empty_pids, p1, p2)
        end
      {pid, cards} ->
        prev_cards = List.keyfind(card_stack, pid, 0)
        new_card_stack = case prev_cards do
          {_, old_cards} ->
            List.keyreplace(card_stack, pid, 0, {pid, old_cards ++ cards})
          nil ->
            [{pid, cards} | card_stack]
        end
        case count do
          0 ->
            play_round(new_card_stack, 1, p1, p2, empty_pids)
          1 ->
            if (Enum.count(empty_pids) > 0), do: end_game(empty_pids, p1, p2)
            play_round(new_card_stack, 0, p1, p2, empty_pids)
        end
    end
  end

  def eval_cards({pid1, cards1}, {pid2, cards2}) do
    values = %{2 => 1, 3 => 2, 4 => 3, 5 => 4, 6 => 5, 7 => 6, 8 => 7, 9 => 8, 10 => 9, "J" => 10, "Q" => 11, "K" => 12, "A" => 13}
    {card1, _} = List.last(cards1)
    {card2, _} = List.last(cards2)
    value1 = values[card1]
    value2 = values[card2]
    cond do
      value1 > value2 ->
        {pid1, cards1 ++ cards2}
      value1 < value2 ->
        {pid2, cards1 ++ cards2}
      true ->
        :tie
    end
  end

  def end_game(empty_pids, p1, p2) do
    case empty_pids do
      [pid] ->
        winner = List.delete([p1, p2], pid) |> List.first
        IO.puts("#{inspect winner} wins")
      [_pid, _pi2] -> IO.puts("It's a tie!")
    end
    Process.exit(self, :game_over)
  end
end
