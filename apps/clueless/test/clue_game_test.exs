defmodule Clueless.ClueGameTest do
  use ExUnit.Case, async: true
  import Clueless.ClueGame
  alias Clueless.ClueGame
  alias Clueless.Answer
  alias Clueless.Question
  alias Clueless.Hand

  doctest ClueGame

  describe "advance_game/1" do
    setup do
      %{
        game:
          ClueGame.new(2, [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20",
            "21"
          ])
      }
    end

    test "can discover a single card of another player", %{game: game} do
      answers = MapSet.new([%Answer{player: 1, cards: MapSet.new(["1", "5"])}])
      hands = %{0 => MapSet.new(["1"])}
      absent_cards = %{1 => MapSet.new(["1"])}

      game = %{game | answers: answers, hands: hands, absent_cards: absent_cards}
      game = ClueGame.advance_game(game)

      # Used all answers
      assert Enum.empty?(game.answers)
      # Goofy doesn't have the 1 card
      assert game.absent_cards[1] |> Enum.to_list() == ["1"]
      # Mickey has the 1 card
      assert game.hands[0] |> Enum.to_list() == ["1"]
      # We discovered that Goofy has the 5 card in hand!
      assert game.hands[1] |> Enum.to_list() == ["5"]
      # So Mickey cannot have the 5 card
      assert game.absent_cards[0] |> Enum.to_list() == ["5"]
    end

    test "can recursively discover cards", %{game: game} do
      answers =
        MapSet.new([
          %Answer{cards: MapSet.new(["1", "5"]), player: 1},
          %Answer{cards: MapSet.new(["5", "2"]), player: 0}
        ])

      hands = %{0 => MapSet.new(["1"])}
      absent_cards = %{1 => MapSet.new(["1"])}

      game = %{game | answers: answers, hands: hands, absent_cards: absent_cards}
      game = ClueGame.advance_game(game)

      # Used all answers
      assert Enum.empty?(game.answers)
      # Absent cards
      assert game.absent_cards[0] |> Enum.to_list() == ["5"]
      assert game.absent_cards[1] |> Enum.to_list() == ["1", "2"]
      # Hands
      assert game.hands[0] |> Enum.to_list() == ["1", "2"]
      assert game.hands[1] |> Enum.to_list() == ["5"]
    end

    test "can discover cards from multiple sources (added question, added card) recursively", %{
      game: game
    } do
      players = 3

      answers =
        MapSet.new([
          %Answer{player: 1, cards: MapSet.new(["1", "2", "7"])},
          %Answer{player: 1, cards: MapSet.new(["3", "6"])},
          %Answer{player: 2, cards: MapSet.new(["7", "6"])}
        ])

      absent_cards = %{1 => MapSet.new(["1", "2", "4"])}
      game = %{game | players: players, answers: answers, absent_cards: absent_cards}

      game = ClueGame.advance_game(game)

      assert game.hands[1] |> Enum.to_list() == ["3", "7"]
      assert game.hands[2] |> Enum.to_list() == ["6"]
    end

    test "when a player asks for cards that nobody has, and they are not in his hand, the cards must be in the solution",
         %{game: game} do
      game =
        %{game | players: 6}
        |> Hand.add_card_to_hand(0, "1")
        |> Hand.add_card_to_hand(0, "2")
        |> Hand.add_card_to_hand(0, "3")
        |> Question.add_question(%Question{
          asked_by: 0,
          answered_by: :nobody,
          cards: MapSet.new(["4", "5", "6"])
        })

      game = ClueGame.advance_game(game)

      assert ClueGame.envelope_cards(game) |> Enum.to_list() == ["4", "5", "6"]
    end
  end
end
