defmodule CluelessCore.ClueGameTest do
  use ExUnit.Case, async: true
  alias CluelessCore.ClueGame
  alias CluelessCore.Answer

  doctest CluelessCore.ClueGame

  describe "advance_game/1" do
    setup do
      %{
        game: %ClueGame{
          players: ["Mickey", "Goofy"]
        }
      }
    end

    test "can discover a single card of another player", %{game: game} do
      answers = MapSet.new([%Answer{player: 1, cards: MapSet.new([:garage, :knife])}])
      hands = %{0 => MapSet.new([:garage])}
      absent_cards = %{1 => MapSet.new([:garage])}

      game = %{game | answers: answers, hands: hands, absent_cards: absent_cards}
      game = ClueGame.advance_game(game)

      # Used all answers
      assert Enum.empty?(game.answers)
      # Goofy doesn't have the garage card
      assert game.absent_cards[1] |> Enum.to_list() == [:garage]
      # Mickey has the garage card
      assert game.hands[0] |> Enum.to_list() == [:garage]
      # We discovered that Goofy has the knife card in hand!
      assert game.hands[1] |> Enum.to_list() == [:knife]
      # So Mickey cannot have the knife card
      assert game.absent_cards[0] |> Enum.to_list() == [:knife]
    end

    test "can recursively discover cards", %{game: game} do
      answers =
        MapSet.new([
          %Answer{cards: MapSet.new([:garage, :knife]), player: 1},
          %Answer{cards: MapSet.new([:knife, :kitchen]), player: 0}
        ])

      hands = %{0 => MapSet.new([:garage])}
      absent_cards = %{1 => MapSet.new([:garage])}

      game = %{game | answers: answers, hands: hands, absent_cards: absent_cards}
      game = ClueGame.advance_game(game)

      # Used all answers
      assert Enum.empty?(game.answers)
      # Absent cards
      assert game.absent_cards[0] |> Enum.to_list() == [:knife]
      assert game.absent_cards[1] |> Enum.to_list() == [:garage, :kitchen]
      # Hands
      assert game.hands[0] |> Enum.to_list() == [:garage, :kitchen]
      assert game.hands[1] |> Enum.to_list() == [:knife]
    end
  end
end
