defmodule CluelessCore.AbsentCard do
  @moduledoc """
  Cards which certainly are not in a player's hand.
  """

  @doc """
    Adds a card to the set of absent cards for a player or a list of players.

    ## Examples

      iex> absent_cards = %{1 => MapSet.new([:knife])}
      iex> absent_cards = add_card_to_absent(absent_cards, 1, :garage)
      iex> Enum.count(Map.get(absent_cards, 1))
      2

      iex> absent_cards = add_card_to_absent(%{}, 2, :knife)
      iex> Enum.count(Map.get(absent_cards, 2))
      1

      iex> absent_cards = %{1 => MapSet.new([:knife])}
      iex> absent_cards = add_card_to_absent(absent_cards, [1, 2], :garage)
      iex> Enum.count(Map.get(absent_cards, 1))
      2
      iex> Enum.count(Map.get(absent_cards, 2))
      1

      iex> absent_cards = add_card_to_absent(%{}, [2], :knife)
      iex> Enum.count(Map.get(absent_cards, 2))
      1

      iex> absent_cards = add_card_to_absent(%{1 => MapSet.new([:knife])}, [], :garage)
      iex> Enum.count(Map.get(absent_cards, 1))
      1

      iex> absent_cards = add_card_to_absent(%{1 => MapSet.new([:knife])}, [2], :knife)
      iex> Enum.count(Map.get(absent_cards, 1))
      1
  """
  def add_card_to_absent(%{} = absent_cards, players, card) when is_list(players) do
    Enum.reduce(players, absent_cards, fn player, absent_cards ->
      add_card_to_absent(absent_cards, player, card)
    end)
  end

  def add_card_to_absent(%{} = absent_cards, player, card) when is_integer(player) do
    {_, absent_cards} =
      Map.get_and_update(absent_cards, player, fn
        nil -> {nil, MapSet.new([card])}
        cards -> {cards, MapSet.put(cards, card)}
      end)

    absent_cards
  end
end
