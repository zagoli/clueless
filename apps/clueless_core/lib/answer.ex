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
  Add a new answer to the set of answers.
  If the answer contains a card that is already in the hand of the player, do nothing.

  ## Examples

      iex> cards = MapSet.new([:garage, :knife, :kitchen])
      iex> player = 1
      iex> answers = Answer.maybe_add_answer(MapSet.new(), cards, player, %{})
      iex> Enum.count(answers)
      1

      iex> cards = MapSet.new([:garage, :knife, :kitchen])
      iex> player = 1
      iex> hands = %{1 => MapSet.new([:garage])}
      iex> answers = Answer.maybe_add_answer(MapSet.new(), cards, player, hands)
      iex> Enum.count(answers)
      0
  """
  def maybe_add_answer(%MapSet{} = answers, %MapSet{} = cards, player, hands)
      when is_integer(player) and is_map(hands) do
    Map.get(hands, player, MapSet.new())
    |> MapSet.intersection(cards)
    |> Enum.empty?()
    |> add_answer(answers, cards, player)
  end

  defp add_answer(true = _no_card_owned, %MapSet{} = answers, %MapSet{} = cards, player) do
    MapSet.put(answers, %__MODULE__{cards: cards, player: player})
  end

  defp add_answer(false = _no_card_owned, %MapSet{} = answers, _, _) do
    answers
  end

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

  @doc """
  Reduce answers by removing cards that are in the absent cards set.
  For every answer, if some cards are in the absent cards set of that player, remove them from the answer.
  """
  def reduce_answers(%MapSet{} = answers, absent_cards) when is_map(absent_cards) do
    Enum.map(answers, fn %__MODULE__{cards: cards, player: player} ->
      player_absent_cards = Map.get(absent_cards, player, MapSet.new())
      new_absent_cards = MapSet.difference(cards, player_absent_cards)
      %__MODULE__{cards: new_absent_cards, player: player}
    end)
    |> MapSet.new()
  end
end
