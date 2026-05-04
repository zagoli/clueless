defmodule Clueless.AbsentCardTest do
  use ExUnit.Case, async: true
  import Clueless.AbsentCard
  alias Clueless.ClueGame

  doctest Clueless.AbsentCard

  describe "add_card_to_absent/3" do

    test "does not add a card to a player's absent set twice" do
      game = %ClueGame{
        players: 1,
        absent_cards: %{0 => MapSet.new([:garage])}
      }

      game = add_card_to_absent(game, 0, :garage)

      assert game.absent_cards[0] |> Enum.to_list() == [:garage]
    end

  end
end
