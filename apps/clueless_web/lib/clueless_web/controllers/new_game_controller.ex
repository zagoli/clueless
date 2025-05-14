defmodule CluelessWeb.NewGameController do
  use CluelessWeb, :controller
  alias Clueless.ClueGame

  def new_game(conn, %{"players" => players_count}) when is_integer(players_count) do
    game = ClueGame.new(players_count)

    conn
    |> put_session(:game, game)
    |> put_resp_content_type("text/plain")
    |> send_resp(201, "")
  end
end
