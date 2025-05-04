defmodule CluelessCore.Hands do
  @moduledoc """
  This module contains the logic for managing hands in the game.
  """

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
    case Map.get(hands, player) do
      nil -> false
      hand -> Enum.member?(hand, card)
    end
  end
end
