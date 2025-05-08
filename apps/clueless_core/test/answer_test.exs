defmodule CluelessCore.AnswerTest do
  use ExUnit.Case, async: true
  alias CluelessCore.Answer

  doctest Answer

  describe "reduce_answers/2" do
    test "removes cards in the absent set" do
      answers =
        MapSet.new([
          %Answer{cards: MapSet.new([:garage, :knife, :kitchen]), player: 1},
          %Answer{cards: MapSet.new([:garage]), player: 2}
        ])

      absent_cards = %{1 => MapSet.new([:garage, :kitchen])}
      reduced_answers = Answer.reduce_answers(answers, absent_cards)

      assert reduced_answers ==
               MapSet.new([
                 %Answer{cards: MapSet.new([:knife]), player: 1},
                 %Answer{cards: MapSet.new([:garage]), player: 2}
               ])
    end
  end
end
