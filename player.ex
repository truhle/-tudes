defmodule Player do
  def player(game_id, hand) do
    receive do
      :request_1 ->
        {card, new_hand} = Enum.split(hand, 1)
        send(game_id, {self(), card})
        player(game_id, new_hand)
      :request_3 ->
        {cards, new_hand} = Enum.split(hand, 3)
        send(game_id, {self(), cards})
        player(game_id, new_hand)
      cards ->
        player(game_id, hand ++ cards)
    end
  end
end
