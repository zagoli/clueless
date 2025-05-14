defmodule Clueless.AbsentCard do
  @moduledoc """
  Cards which certainly are not in a player's hand.
  """

  @doc """
    Adds a card or set of cards to the set of absent cards for a player or a list of players.

    ## Returns
    The updated map of absent cards, where each key is a player ID and the value is a `MapSet` of absent cards.

    ## Examples

      iex> absent_cards = %{1 => MapSet.new([:knife])}
      iex> absent_cards = add_card_to_absent(absent_cards, 1, :garage)
      iex> absent_cards[1]
      MapSet.new([:knife, :garage])

      iex> absent_cards = add_card_to_absent(%{}, 2, :knife)
      iex> absent_cards[2]
      MapSet.new([:knife])

      iex> absent_cards = %{1 => MapSet.new([:knife])}
      iex> absent_cards = add_card_to_absent(absent_cards, [1, 2], :garage)
      iex> absent_cards[1]
      MapSet.new([:knife, :garage])
      iex> absent_cards[2]
      MapSet.new([:garage])

      iex> absent_cards = add_card_to_absent(%{}, [2], :knife)
      iex> absent_cards[2]
      MapSet.new([:knife])

      iex> absent_cards = add_card_to_absent(%{1 => MapSet.new([:knife])}, [], :garage)
      iex> absent_cards[1]
      MapSet.new([:knife])

      iex> absent_cards = add_card_to_absent(%{1 => MapSet.new([:knife])}, [2], :knife)
      iex> absent_cards[1]
      MapSet.new([:knife])

      iex> absent_cards = add_card_to_absent(%{}, 1, MapSet.new([:garage, :knife]))
      iex> absent_cards[1]
      MapSet.new([:garage, :knife])

      iex> absent_cards = add_card_to_absent(%{}, [1, 2], MapSet.new([:garage, :knife]))
      iex> absent_cards[1]
      MapSet.new([:garage, :knife])
      iex> absent_cards[2]
      MapSet.new([:garage, :knife])

  """
  def add_card_to_absent(absent_cards, players, %MapSet{} = cards)
      when is_map(absent_cards) do
    Enum.reduce(cards, absent_cards, fn card, absent_cards ->
      add_card_to_absent(absent_cards, players, card)
    end)
  end

  def add_card_to_absent(absent_cards, players, card)
      when is_list(players) and is_map(absent_cards) do
    Enum.reduce(players, absent_cards, fn player, absent_cards ->
      add_card_to_absent(absent_cards, player, card)
    end)
  end

  def add_card_to_absent(absent_cards, player, card)
      when is_integer(player) and is_map(absent_cards) and is_atom(card) do
    Map.update(absent_cards, player, MapSet.new([card]), fn
      cards -> MapSet.put(cards, card)
    end)
  end
end
