defmodule Clueless.Hand do
  @moduledoc """
  This module contains the logic for managing hands in the game.
  """
  alias Clueless.ClueGame
  alias Clueless.AbsentCard
  alias Clueless.Player

  @doc """
  Adds a card to a player's hand and computes the new game state.
  If the player already has the maximum number of cards in their hand, the game state is not modified.

  ## Parameters
    - `Clueless.ClueGame`: the current game state.
    - `player`: the player to whom the card is being added.
    - `card`: the card being added to the player's hand.

  ## Returns
    - `Clueless.ClueGame`: the updated game state.

  ## Examples

      iex> game = ClueGame.new(2, ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21"])
      iex> add_card_to_hand(game, 0, "1")
      %ClueGame{hands: %{0 => MapSet.new(["1"]), 1 => MapSet.new()}, absent_cards: %{0 => MapSet.new(), 1 => MapSet.new(["1"])}, answers: MapSet.new(), revealed_cards: MapSet.new(), players: 2, all_cards: MapSet.new(["1", "10", "11", "12", "13","14", "15", "16", "17", "18", "19", "2", "20", "21","3", "4", "5", "6", "7", "8", "9"])}
  """
  def add_card_to_hand(%ClueGame{} = game, player, card)
      when is_integer(player) do
    max_hand_size = max_hand_size(game.players, Enum.count(game.all_cards))

    if player_hand_size(game.hands, player) >= max_hand_size do
      game
    else
      hands = add_card_to_player_hand(game.hands, player, card)

      absent_cards =
        AbsentCard.add_card_to_absent(
          game.absent_cards,
          Player.players_between(game.players, player, player),
          card
        )

      absent_cards =
        if player_hand_size(hands, player) == max_hand_size do
          AbsentCard.add_card_to_absent(
            absent_cards,
            player,
            MapSet.difference(game.all_cards, hands[player])
          )
        else
          absent_cards
        end

      %{game | hands: hands, absent_cards: absent_cards}
      |> ClueGame.advance_game()
    end
  end

  defp add_card_to_player_hand(hands, player, card) do
    Map.update(hands, player, MapSet.new([card]), fn
      hand -> MapSet.put(hand, card)
    end)
  end

  defp player_hand_size(hands, player) when is_map(hands) and is_integer(player) do
    player_hand = hands[player]
    if player_hand, do: Enum.count(player_hand), else: 0
  end

  @doc """
  Returns the maximum hand size for a given number of players and total cards.

  ## Examples

      iex> Clueless.Hand.max_hand_size(3, 21)
      6
  """
  def max_hand_size(players, number_of_cards)
      when is_integer(players) and is_integer(number_of_cards) do
    # The total number of cards is reduced by 3 to account for the 3 cards that are set aside as the answer.
    Integer.floor_div(number_of_cards - 3, players)
  end
end
