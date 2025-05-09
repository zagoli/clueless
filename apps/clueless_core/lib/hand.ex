defmodule CluelessCore.Hand do
  @moduledoc """
  This module contains the logic for managing hands in the game.
  """
  alias CluelessCore.ClueGame
  alias CluelessCore.AbsentCard
  alias CluelessCore.Answer
  alias CluelessCore.Player

  @doc """
  Adds a card to a player's hand and computes the new game state.

  ## Parameters
    - `CluelessCore.ClueGame`: the current game state.
    - `player`: the player to whom the card is being added.
    - `card`: the card being added to the player's hand.

  ## Returns
    - `CluelessCore.ClueGame`: the updated game state.

  ## Examples

      iex> game = %ClueGame{hands: %{}, absent_cards: %{}, answers: MapSet.new(), players: ["Mickey", "Goofy"]}
      iex> add_card_to_hand(game, "Mickey", :garage)
      %ClueGame{hands: %{0 => MapSet.new([:garage])}, absent_cards: %{1 => MapSet.new([:garage])}, answers: MapSet.new(), players: ["Mickey", "Goofy"]}
  """
  def add_card_to_hand(%ClueGame{} = game, player, card)
      when is_binary(player) and is_atom(card) do
    add_card_to_hand(game, Player.get_player_index(game.players, player), card)
  end

  def add_card_to_hand(%ClueGame{} = game, player, card)
      when is_integer(player) and is_atom(card) do
    hands = add_card_to_player_hand(game.hands, player, card)

    absent_cards =
      AbsentCard.add_card_to_absent(
        game.absent_cards,
        Player.players_between(game.players, player, player),
        card
      )

    # TODO: EXTRACT METHOD

    answers = Answer.reduce_answers(game.answers, absent_cards)
    discovered_answers = Answer.discover_cards_in_hand(answers)
    answers = Answer.remove_answers(answers, discovered_answers)

    if not Enum.empty?(discovered_answers) do
      Enum.reduce(discovered_answers, game, fn %Answer{cards: cards, player: player}, game ->
        add_card_to_hand(game, player, cards)
      end)
    else
      %{game | hands: hands, absent_cards: absent_cards, answers: answers}
    end

    # END TODO: EXTRACT METHOD
  end

  defp add_card_to_player_hand(hands, player, card) do
    {_, hands} =
      Map.get_and_update(hands, player, fn
        nil -> {nil, MapSet.new([card])}
        hand -> {hand, MapSet.put(hand, card)}
      end)

    hands
  end

  @doc """
  Checks if a specific card is present in a player's hand.

  ## Returns
    - `true` if the card is in the player's hand
    - `false` if the player doesn't exist or doesn't have the card

  ## Examples

      iex> hands = %{"player1" => [:garage, :kitchen], "player2" => [:knife]}
      iex> in_hand?(hands, "player1", :garage)
      true

      iex> hands = %{"player1" => [:garage, :kitchen], "player2" => [:knife]}
      iex> in_hand?(hands, "player1", :knife)
      false

      iex> hands = %{"player1" => [:garage, :kitchen], "player2" => [:knife]}
      iex> in_hand?(hands, "player3", :garage)
      false
  """
  def in_hand?(hands, player, card) when is_map(hands) and is_binary(player) and is_atom(card) do
    case hands[player] do
      nil -> false
      hand -> Enum.member?(hand, card)
    end
  end
end
