defmodule CluelessCore.ClueGame do
  @moduledoc """
  This module contains the logic for managing the state of a Clue game.
  """
  alias CluelessCore.Answer
  alias CluelessCore.Hand

  @doc """
  A struct representing the state of a Clue game.
  """
  defstruct hands: %{}, absent_cards: %{}, questions: [], answers: MapSet.new(), players: []

  @doc """
  Advances the game state by processing the answers and updating the players' hands and absent cards sets.
  """
  def advance_game(game) do
    answers = Answer.reduce_answers(game.answers, game.absent_cards)
    discovered_answers = Answer.discover_cards_in_hand(answers)
    answers = Answer.remove_answers(answers, discovered_answers)

    game = %{game | answers: answers}

    if not Enum.empty?(discovered_answers) do
      Enum.reduce(discovered_answers, game, fn %Answer{cards: cards, player: player}, game ->
        # every discovered answer has only a card
        card = cards |> Enum.to_list() |> List.first()
        Hand.add_card_to_hand(game, player, card)
      end)
    else
      game
    end
  end
end
