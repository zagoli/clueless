defmodule Clueless.HandTest do
  use ExUnit.Case, async: true
  import Clueless.Hand
  alias Clueless.ClueGame
  alias Clueless.Answer

  doctest Clueless.Hand

  describe "add_card_to_hand/3" do
    test "adds a card and advance game" do
      game = %ClueGame{
        players: 2,
        answers: MapSet.new([%Answer{cards: MapSet.new([:garage, :knife]), player: 1}])
      }

      game = add_card_to_hand(game, 0, :garage)

      # Used all answers
      assert Enum.empty?(game.answers)

      # Garage card was added to Mickey's hand
      assert game.hands[0] |> Enum.to_list() == [:garage]
      # Used all answers (game advanced)
      assert Enum.empty?(game.answers)
    end

    test "does not add a card twice to the same player's hand" do
      game = %ClueGame{
        players: 1,
        hands: %{0 => MapSet.new([:garage])}
      }

      game = add_card_to_hand(game, 0, :garage)

      assert game.hands[0] |> Enum.to_list() == [:garage]
    end

    test "does not add a card if the player already has the maximum number of cards in his hand" do
      game = %ClueGame{
        players: 6,
        hands: %{0 => MapSet.new([:garage, :knife, :kitchen])}
      }

      game = add_card_to_hand(game, 0, :plum)

      refute Enum.member?(game.hands[0], :plum)
    end

    test "adds every card not in hand to player's absent cards at max hand size" do
      game = %ClueGame{
        players: 6,
        hands: %{0 => MapSet.new([:garage, :knife])},
        absent_cards: %{0 => MapSet.new()}
      }

      game = add_card_to_hand(game, 0, :plum)

      assert Enum.count(game.absent_cards[0]) == 21 - 3 - 3 # 21 total cards - 3 in the envelope - 3 in the player's hand
      assert MapSet.intersection(game.hands[0], game.absent_cards[0]) |> Enum.empty?()
    end
  end

  describe "max_hand_size/1" do
    test "returns the maximum hand size for a given number of players" do
      assert max_hand_size(3) == 6
      assert max_hand_size(4) == 4
      assert max_hand_size(5) == 3
      assert max_hand_size(6) == 3
    end
  end
end
