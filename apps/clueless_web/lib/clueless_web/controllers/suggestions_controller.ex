defmodule CluelessWeb.SuggestionsController do
  use CluelessWeb, :controller
  alias Clueless.ClueGame

  def suggestions(conn, _params) do
    game = get_session(conn, :game)
    cards_suspect_score = ClueGame.cards_suspect_score(game.absent_cards)
    render(conn, :suggestions, cards_suspect_score: cards_suspect_score)
  end
end
