defmodule CluelessWeb.RevealCardController do
  use CluelessWeb, :controller
  alias Clueless.RevealedCard

  plug :put_view, CluelessWeb.ClueGameHintsJSON

  def reveal_card(conn, %{"card" => card}) when is_binary(card) do
    old_game = get_session(conn, :game)
    new_game = RevealedCard.reveal_card(old_game, card)

    conn
    |> put_session(:game, new_game)
    |> assign(:old_game, old_game)
    |> assign(:new_game, new_game)
    |> render(:clue_game_hints)
  end
end
