defmodule CluelessCore.Question do
  @moduledoc """
  This module contains the logic for creating and adding questions.
  """
  alias CluelessCore.ClueGame
  alias CluelessCore.Answer
  alias CluelessCore.AbsentCard
  alias CluelessCore.Player

  @doc """
  A question asked by a player in his turn.
  asked_by: the name of the player who asked the question
  answered_by: the name of the player who answered the question or :nobody
  cards: a %MapSet{} of cards that were asked
  """
  defstruct asked_by: "", answered_by: :nobody, cards: MapSet.new()

  @doc """
  Adds a question to the game and updates the game state accordingly.

  ## Parameters
  - `CluelessCore.ClueGame` game: The current state of the game.
  - `CluelessCore.Question` question: The question to be added.

  ## Returns
  - `CluelessCore.ClueGame`: The updated game state with the new question added.
  """
  def add_question(%ClueGame{} = game, %__MODULE__{} = question) do
    player_who_answered = who_answered?(game.players, question.answered_by)

    answers =
      Answer.maybe_add_answer(game.answers, question.cards, player_who_answered, game.hands)

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

  defp who_answered?(_, :nobody), do: :nobody
  defp who_answered?(players, answered_by), do: Player.get_player_index(players, answered_by)

  defp add_to_absent(absent_cards, players, asked_by, :nobody, cards_to_add) do
    players = Player.players_between(players, asked_by, asked_by)
    AbsentCard.add_card_to_absent(absent_cards, players, cards_to_add)
  end

  defp add_to_absent(absent_cards, players, asked_by, answered_by, cards_to_add) do
    players = Player.players_between(players, asked_by, answered_by)
    AbsentCard.add_card_to_absent(absent_cards, players, cards_to_add)
  end
end
