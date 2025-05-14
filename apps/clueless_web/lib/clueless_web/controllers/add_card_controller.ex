defmodule CluelessWeb.AddCardController do
  use CluelessWeb, :controller
  alias Clueless.Hand

  plug :put_view, CluelessWeb.ClueGameHintsJson

  def(
    add_card(conn, %{"card" => card, "player" => player})
    when is_binary(card) and is_integer(player)
  ) do
    old_game = get_session(conn, :game)
    new_game = Hand.add_card_to_hand(old_game, player, card)

    conn
    |> put_session(:game, new_game)
    |> assign(:old_game, old_game)
    |> assign(:new_game, new_game)
    |> render(:clue_game_hints)
  end
end
