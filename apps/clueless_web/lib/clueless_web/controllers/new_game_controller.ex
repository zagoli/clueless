defmodule CluelessWeb.NewGameController do
  use CluelessWeb, :controller
  alias Clueless.ClueGame

  def new_game(conn, %{"players" => players_count, "cards" => cards})
      when is_integer(players_count) and is_list(cards) do
    game = ClueGame.new(players_count, cards)

    conn
    |> put_session(:game, game)
    |> put_resp_content_type("text/plain")
    |> send_resp(201, "")
  end
end
