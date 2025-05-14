defmodule Clueless.Question do
  @moduledoc """
  This module contains the logic for creating and adding questions.
  """
  alias Clueless.ClueGame
  alias Clueless.Answer
  alias Clueless.AbsentCard
  alias Clueless.Player

  @doc """
  A question asked by a player in his turn.
  asked_by: the index of the player who asked the question
  answered_by: the index of the player who answered the question or :nobody
  cards: a %MapSet{} of cards that were asked
  """
  defstruct asked_by: 0, answered_by: :nobody, cards: MapSet.new()

  @doc """
  Adds a question to the game and updates the game state accordingly.

  ## Parameters
  - `Clueless.ClueGame` game: The current state of the game.
  - `Clueless.Question` question: The question to be added.

  ## Returns
  - `Clueless.ClueGame`: The updated game state with the new question added.
  """
  def add_question(%ClueGame{} = game, %__MODULE__{} = question) do
    answers =
      Answer.maybe_add_answer(game.answers, question.cards, question.answered_by, game.hands)

    absent_cards =
      add_to_absent(
        game.absent_cards,
        game.players,
        question.asked_by,
        question.answered_by,
        question.cards
      )

    game = %{game | answers: answers, absent_cards: absent_cards}

    ClueGame.advance_game(game)
  end

  defp add_to_absent(absent_cards, players, asked_by, :nobody, cards_to_add) do
    players = Player.players_between(players, asked_by, asked_by)
    AbsentCard.add_card_to_absent(absent_cards, players, cards_to_add)
  end

  defp add_to_absent(absent_cards, players, asked_by, answered_by, cards_to_add) do
    players = Player.players_between(players, asked_by, answered_by)
    AbsentCard.add_card_to_absent(absent_cards, players, cards_to_add)
  end
end
