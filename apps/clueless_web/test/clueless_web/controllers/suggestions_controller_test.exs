defmodule CluelessWeb.SuggestionsControllerTest do
  use CluelessWeb.ConnCase, async: true
  import CluelessWeb.GameFixtures

  defp add_questions(%{conn: conn}) do
    conn =
      conn
      |> post(~p"/api/add_question",
        asked_by: 0,
        answered_by: 2,
        cards: ["garage", "knife", "kitchen"]
      )
      |> post(~p"/api/add_question",
        asked_by: 0,
        answered_by: -1,
        cards: ["bathroom", "bucket", "living room"]
      )

    %{conn: conn}
  end

  describe "GET suggestions" do
    setup [:create_game, :add_questions]

    test "returns cards suspect score", %{conn: conn} do
      conn = get(conn, ~p"/api/suggestions")

      response = json_response(conn, 200)

      assert get_in(response, ["cards_suspect_score", "bathroom"]) == 2
      assert get_in(response, ["cards_suspect_score", "garage"]) == 1
    end
  end
end
