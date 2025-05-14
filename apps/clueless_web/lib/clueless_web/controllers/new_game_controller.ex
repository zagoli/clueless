defmodule CluelessWeb.NewGameController do
  use CluelessWeb, :controller
  alias Clueless.ClueGame

  def new_game(conn, %{"players" => players}) when is_list(players) do
    game = ClueGame.new(Enum.count(players))

    conn
    |> fetch_session()
    |> put_session(:players, players)
    |> put_session(:game, game)
    |> put_resp_content_type("text/plain")
    |> send_resp(201, "")
  end
end
