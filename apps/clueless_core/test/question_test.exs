defmodule CluelessCore.QuestionTest do
  use ExUnit.Case, async: true
  alias CluelessCore.Question
  alias CluelessCore.ClueGame
  alias CluelessCore.Answer

  doctest CluelessCore.Question

  describe("add_question/2") do
    test "adds a question and advances the game" do
      game = %ClueGame{
        players: ["Alice", "Bob", "Terry"],
        answers: MapSet.new([%Answer{player: 1, cards: MapSet.new([:knife, :garage, :kitchen])}])
      }

      question = %Question{
        asked_by: "Alice",
        answered_by: "Terry",
        cards: MapSet.new([:knife, :kitchen])
      }

      game = Question.add_question(game, question)

      # The game advanced
      assert game.hands[1] |> Enum.to_list() == [:garage]
    end
  end
end
