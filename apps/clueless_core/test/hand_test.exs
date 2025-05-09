defmodule CluelessCore.HandTest do
  use ExUnit.Case, async: true
  import CluelessCore.Hand
  alias CluelessCore.ClueGame
  alias CluelessCore.Answer

  doctest CluelessCore.Hand

  describe("add_card_to_hand/3") do
    setup do
      %{
        game: %ClueGame{
          players: ["Mickey", "Goofy"],
          hands: %{},
          absent_cards: %{},
          answers: MapSet.new()
        }
      }
    end

    test "can discover a single card of another player", %{game: game} do
      answers =
        Answer.maybe_add_answer(
          game.answers,
          MapSet.new([:garage, :knife]),
          1,
          game.hands
        )

      game = %{game | answers: answers}
      game = add_card_to_hand(game, "Mickey", :garage)

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
        game.answers
        |> Answer.maybe_add_answer(MapSet.new([:garage, :knife]), 1, game.hands)
        |> Answer.maybe_add_answer(MapSet.new([:knife, :kitchen]), 0, game.hands)

      game = %{game | answers: answers}
      game = add_card_to_hand(game, "Mickey", :garage)

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
