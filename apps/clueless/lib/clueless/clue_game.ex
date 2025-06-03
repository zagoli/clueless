defmodule Clueless.ClueGame do
  @moduledoc """
  This module contains the logic for managing the state of a Clue game.
  """
  alias Clueless.Answer
  alias Clueless.Hand

  @doc """
  A struct representing the state of a Clue game.
  """
  defstruct hands: %{},
            absent_cards: %{},
            answers: MapSet.new(),
            revealed_cards: MapSet.new(),
            players: 0

  @doc """
  Creates a new game with the specified number of players.

  ## Examples

      iex> ClueGame.new(2)
      %ClueGame{players: 2, hands: %{0 => MapSet.new(), 1 => MapSet.new()}, absent_cards: %{0 => MapSet.new(), 1 => MapSet.new()}, answers: MapSet.new(), revealed_cards: MapSet.new()}
  """
  def new(players) when is_integer(players) and players > 0 do
    %__MODULE__{
      players: players,
      hands: init_player_map(players),
      absent_cards: init_player_map(players)
    }
  end

  defp init_player_map(players) do
    0..(players - 1)
    |> Enum.map(fn player -> {player, MapSet.new()} end)
    |> Enum.into(%{})
  end

  @doc """
  Advances the game state by processing the answers and updating the players' hands and absent cards sets.
  """
  def advance_game(%__MODULE__{} = game) do
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

  @doc """
  Returns a list of cards that are certainly present in the envelope in a certain point of the game.
  A card is considered present in the envelope if it is not present in any player's hand (it is present in every player absent cards set),
  but it is not a revealed card.

  ## Examples

      iex> game = %ClueGame{absent_cards: %{0 => MapSet.new([:garage]), 1 => MapSet.new([:garage, :knife])}, revealed_cards: MapSet.new()}
      iex> ClueGame.envelope_cards(game)
      [:garage]

      iex> game = %ClueGame{absent_cards: %{0 => MapSet.new([:garage]), 1 => MapSet.new([:knife])}, revealed_cards: MapSet.new()}
      iex> ClueGame.envelope_cards(game)
      []

      iex> game = %ClueGame{absent_cards: %{0 => MapSet.new([:garage]), 1 => MapSet.new()}, revealed_cards: MapSet.new()}
      iex> ClueGame.envelope_cards(game)
      []

      iex> game = %ClueGame{absent_cards: %{0 => MapSet.new([:garage]), 1 => MapSet.new([:garage])}, revealed_cards: MapSet.new([:garage])}
      iex> ClueGame.envelope_cards(game)
      []
  """
  def envelope_cards(%__MODULE__{} = game) do
    game.absent_cards
    |> Map.values()
    |> Enum.reduce(fn envelope, absent_for_player ->
      MapSet.intersection(envelope, absent_for_player)
    end)
    |> Enum.to_list()
    |> Enum.reject(&(&1 in game.revealed_cards))
  end

  @doc """
  Returns a keyword list of cards with the number of times they are present in an absent set.
  If a card is in the envelope or in a hand, it is not included.

  ## Example

      iex> absent_cards = %{0 => MapSet.new([:garage]), 1 => MapSet.new([:garage, :knife])}
      iex> result = cards_suspect_score(%ClueGame{absent_cards: absent_cards})
      iex> result[:knife]
      1

      iex> absent_cards = %{0 => MapSet.new([:garage]), 1 => MapSet.new([:knife]), 2 => MapSet.new([:knife])}
      iex> hands = %{2 => MapSet.new([:garage])}
      iex> result = cards_suspect_score(%ClueGame{absent_cards: absent_cards, hands: hands})
      iex> result[:knife]
      2
      iex> result[:garage]
      nil
  """
  def cards_suspect_score(%__MODULE__{} = game) do
    envelope = envelope_cards(game)
    hands = game.hands |> Map.values() |> Enum.reduce(MapSet.new(), &MapSet.union(&1, &2))

    game.absent_cards
    |> Map.values()
    |> Enum.flat_map(&Enum.to_list(&1))
    |> Enum.reject(&(&1 in envelope))
    |> Enum.reject(&(&1 in hands))
    |> Enum.frequencies()
    |> Enum.to_list()
  end
end
