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

      iex> game = ClueGame.new(2)
      iex> add_card_to_hand(game, 0, :garage)
      %ClueGame{hands: %{0 => MapSet.new([:garage]), 1 => MapSet.new()}, absent_cards: %{0 => MapSet.new(), 1 => MapSet.new([:garage])}, answers: MapSet.new(), players: 2}
  """
  def add_card_to_hand(%ClueGame{} = game, player, card)
      when is_integer(player) do
    if Enum.count(game.hands[player]) >= max_hand_size(game.players) do
      game
    else
      hands = add_card_to_player_hand(game.hands, player, card)

      absent_cards =
        AbsentCard.add_card_to_absent(
          game.absent_cards,
          Player.players_between(game.players, player, player),
          card
        )

      game = %{game | hands: hands, absent_cards: absent_cards}

      ClueGame.advance_game(game)
    end
  end

  defp add_card_to_player_hand(hands, player, card) do
    Map.update(hands, player, MapSet.new([card]), fn
      hand -> MapSet.put(hand, card)
    end)
  end

  @doc """
  Returns the maximum hand size for a given number of players.

  ## Examples

      iex> Clueless.Hand.max_hand_size(3)
      6
  """
  def max_hand_size(players) when is_integer(players) do
    # 18 = 21 cards total - 3 cards in the envelope
    Integer.floor_div(18, players)
  end
end
