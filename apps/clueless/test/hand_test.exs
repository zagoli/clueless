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
        answers: MapSet.new([%Answer{cards: MapSet.new(["garage", "knife"]), player: 1}])
      }

      game = add_card_to_hand(game, 0, "garage")

      # Used all answers
      assert Enum.empty?(game.answers)

      # Garage card was added to Mickey's hand
      assert game.hands[0] |> Enum.to_list() == ["garage"]
      # Used all answers (game advanced)
      assert Enum.empty?(game.answers)
    end

    test "does not add a card twice to the same player's hand" do
      game = %ClueGame{
        players: 1,
        hands: %{0 => MapSet.new(["garage"])}
      }

      game = add_card_to_hand(game, 0, "garage")

      assert game.hands[0] |> Enum.to_list() == ["garage"]
    end

    test "does not add a card if the player already has the maximum number of cards in his hand" do
      game = %ClueGame{
        players: 6,
        hands: %{0 => MapSet.new(["garage", "knife", "kitchen"])}
      }

      game = add_card_to_hand(game, 0, "plum")

      refute Enum.member?(game.hands[0], "plum")
    end

    test "adds every card not in hand to player's absent cards at max hand size" do
      game = %ClueGame{
        players: 6,
        hands: %{0 => MapSet.new(["1", "2"])},
        absent_cards: %{0 => MapSet.new()}
      }

      game = add_card_to_hand(game, 0, "3")

      assert game.absent_cards[0] |> Enum.count() == 18
      assert MapSet.intersection(game.hands[0], game.absent_cards[0]) |> Enum.empty?()
    end
  end

  describe "max_hand_size/2" do
    test "returns the maximum hand size for a given number of players and total cards" do
      assert max_hand_size(3, 21) == 6
      assert max_hand_size(4, 21) == 4
      assert max_hand_size(5, 21) == 3
      assert max_hand_size(6, 21) == 3
    end
  end
end
