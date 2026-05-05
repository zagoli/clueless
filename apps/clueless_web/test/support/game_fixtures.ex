defmodule CluelessWeb.GameFixtures do
  use CluelessWeb, :verified_routes
  import Phoenix.ConnTest

  def create_game(%{conn: conn}) do
    conn =
      post(conn, ~p"/api/new_game",
        players: 3,
        cards: [
          "1",
          "2",
          "3",
          "4",
          "5",
          "6",
          "7",
          "8",
          "9",
          "10",
          "11",
          "12",
          "13",
          "14",
          "15",
          "16",
          "17",
          "18",
          "19",
          "20",
          "21"
        ]
      )

    %{conn: conn}
  end
end
