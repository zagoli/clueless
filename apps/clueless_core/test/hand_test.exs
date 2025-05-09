defmodule CluelessCore.HandTest do
  use ExUnit.Case, async: true
  import CluelessCore.Hand
  alias CluelessCore.ClueGame
  alias CluelessCore.Answer

  doctest CluelessCore.Hand

  describe "add_card_to_hand/3" do
    test "adds a card and advance game" do
      game = %ClueGame{
        players: ["Mickey", "Goofy"],
        hands: %{},
        absent_cards: %{},
        answers: MapSet.new([%Answer{cards: MapSet.new([:garage, :knife]), player: 1}])
      }

      game = add_card_to_hand(game, "Mickey", :garage)

      # Used all answers
      assert Enum.empty?(game.answers)

      # Garage card was added to Mickey's hand
      assert game.hands[0] |> Enum.to_list() == [:garage]
      # Used all answers (game advanced)
      assert Enum.empty?(game.answers)
    end
  end
end
