defmodule Clueless.RevealedCardTest do
  use ExUnit.Case, async: true
  import Clueless.RevealedCard
  alias Clueless.ClueGame
  alias Clueless.Answer

  doctest Clueless.RevealedCard

  describe "reveal_card/2" do
    test "advances the game" do
      game =
        %ClueGame{
          players: 3,
          answers: MapSet.new([%Answer{player: 2, cards: MapSet.new([:knife, :garage])}])
        }
        |> reveal_card(:garage)

      assert game.revealed_cards == MapSet.new([:garage])
      assert game.hands[2] == MapSet.new([:knife])
    end
  end
end
