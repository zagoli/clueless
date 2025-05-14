defmodule CluelessWeb.AddQuestionControllerTest do
  use CluelessWeb.ConnCase, async: true
  import CluelessWeb.GameFixtures

  describe "POST add_question" do
    setup [:create_game]

    test "adds a question to the game", %{conn: conn} do
      conn =
        post(conn, ~p"/api/add_question",
          asked_by: 0,
          answered_by: 2,
          cards: ["garage", "kitchen"]
        )

      response = json_response(conn, 200)

      assert get_in(response, ["diff", "absent_cards", "1"]) == ["garage", "kitchen"]
    end

    test "only returns the difference, but game state contains all answers", %{conn: conn} do
      conn =
        conn
        |> post(~p"/api/add_question",
          asked_by: 0,
          answered_by: 2,
          cards: ["garage", "kitchen"]
        )
        |> post(~p"/api/add_question",
          asked_by: 0,
          answered_by: 2,
          cards: ["bathroom", "kitchen"]
        )

      response = json_response(conn, 200)

      assert get_in(response, ["diff", "absent_cards", "1"]) == ["bathroom"]

      game = get_session(conn, :game)
      assert Enum.count(game.answers) == 2
    end
  end
end
