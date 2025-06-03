defmodule Clueless.RevealedCard do
  @moduledoc """
  Cards which are revealed to every player.
  """
  alias Clueless.AbsentCard
  alias Clueless.ClueGame
  alias Clueless.Player

  @doc """
  Reveal a card: add this card to the absent set of every player and to the set of revealed cards.

  ## Returns
  The updated `Clueless.ClueGame`.

  ## Examples

      iex> game = Clueless.ClueGame.new(2)
      iex> game = reveal_card(game, :knife)
      iex> game.revealed_cards
      MapSet.new([:knife])
      iex> game.absent_cards[0]
      MapSet.new([:knife])
      iex> game.absent_cards[1]
      MapSet.new([:knife])
  """
  def reveal_card(%ClueGame{} = game, card) do
    revealed_cards = MapSet.put(game.revealed_cards, card)
    all_players = Player.all_players(game.players)
    absent_cards = AbsentCard.add_card_to_absent(game.absent_cards, all_players, card)
    game = %{game | absent_cards: absent_cards, revealed_cards: revealed_cards}
    ClueGame.advance_game(game)
  end
end
