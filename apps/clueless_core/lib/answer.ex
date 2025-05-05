defmodule CluelessCore.Answer do
  @moduledoc """
  An answer to a CluelessCore.Question.
  Used to discover new cards in players' hands.
  """

  @doc """
  An answer to a question asked by a player.
  cards: a %MapSet{} of cards that were asked
  player: the index of the player who answered the question
  """
  defstruct ~w[cards player]a

  @doc """
  Removes answers with less than two cards.

  ## Example

      iex> answers = MapSet.new([%Answer{cards: MapSet.new([:garage, :knife]), player: 1}, %Answer{cards: MapSet.new([:garage]), player: 2}])
      iex> answers = Answer.remove_exhausted_answers(answers)
      iex> MapSet.size(answers)
      1

  """
  def remove_exhausted_answers(%MapSet{} = answers) do
    MapSet.reject(answers, fn answer ->
      MapSet.size(answer.cards) < 2
    end)
  end
end
