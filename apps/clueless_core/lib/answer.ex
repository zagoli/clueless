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
  Remove answers from a set of answers.

  ## Examples

      iex> answers = MapSet.new([%Answer{cards: MapSet.new([:garage, :knife]), player: 1}, %Answer{cards: MapSet.new([:garage]), player: 2}])
      iex> answers_to_remove = MapSet.new([%Answer{cards: MapSet.new([:garage]), player: 2}])
      iex> answers = Answer.remove_answers(answers, answers_to_remove)
      iex> Enum.count(answers)
      1

      iex> answers = MapSet.new([%Answer{cards: MapSet.new([:garage, :knife]), player: 1}, %Answer{cards: MapSet.new([:garage]), player: 2}])
      iex> answers_to_remove = MapSet.new([%Answer{cards: MapSet.new([:kitchen]), player: 2}])
      iex> answers = Answer.remove_answers(answers, answers_to_remove)
      iex> Enum.count(answers)
      2
  """
  def remove_answers(%MapSet{} = answers, %MapSet{} = answers_to_remove) do
    MapSet.difference(answers, answers_to_remove)
  end

  @doc """
  Find answers with only one card.

  ## Example

      iex> answers = MapSet.new([%Answer{cards: MapSet.new([:garage, :knife]), player: 1}, %Answer{cards: MapSet.new([:garage]), player: 2}])
      iex> found_answers = Answer.discover_cards_in_hand(answers)
      iex> Enum.count(found_answers)
      1
  """
  def discover_cards_in_hand(%MapSet{} = answers) do
    MapSet.filter(answers, fn answer ->
      Enum.count(answer.cards) == 1
    end)
  end
end
