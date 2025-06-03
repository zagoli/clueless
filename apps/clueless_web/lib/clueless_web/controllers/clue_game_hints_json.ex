defmodule CluelessWeb.ClueGameHintsJSON do
  alias Clueless.ClueGame

  def clue_game_hints(%{new_game: new_game, old_game: old_game}) do
    %{
      diff: %{
        hands: difference(new_game.hands, old_game.hands),
        absent_cards: difference(new_game.absent_cards, old_game.absent_cards),
        revealed_cards:
          MapSet.difference(new_game.revealed_cards, old_game.revealed_cards) |> Enum.to_list()
      },
      envelope: ClueGame.envelope_cards(new_game)
    }
  end

  defp difference(map_1, map_2) do
    Enum.map(0..(Enum.count(map_1) - 1), fn i ->
      {i, MapSet.difference(map_1[i], map_2[i]) |> Enum.to_list()}
    end)
    |> Enum.filter(fn {_, v} -> not Enum.empty?(v) end)
    |> Enum.into(%{})
  end
end
