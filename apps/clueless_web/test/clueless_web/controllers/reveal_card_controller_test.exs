defmodule CluelessWeb.RevealCardControllerTest do
  use CluelessWeb.ConnCase, async: true
  import CluelessWeb.GameFixtures

  describe("POST reveal_card") do
    setup [:create_game]

    test "reveals a card", %{conn: conn} do
      conn = post(conn, ~p"/api/reveal_card", card: "garage")

      response = json_response(conn, 200)
      assert get_in(response, ["diff", "revealed_cards"]) == ["garage"]
      assert get_in(response, ["diff", "absent_cards", "0"]) == ["garage"]
      assert get_in(response, ["diff", "absent_cards", "1"]) == ["garage"]
      assert get_in(response, ["diff", "absent_cards", "2"]) == ["garage"]
    end

    test "revealed card not in envelope", %{conn: conn} do
      conn =
        conn
        |> post(~p"/api/add_question",
          asked_by: 0,
          answered_by: -1,
          cards: ["garage"]
        )
        |> post(~p"/api/add_question",
          asked_by: 1,
          answered_by: -1,
          cards: ["garage"]
        )

      response = json_response(conn, 200)
      # If the card is not revealed, it should be in the envelope
      assert get_in(response, ["envelope"]) == ["garage"]

      conn = post(conn, ~p"/api/reveal_card", card: "garage")

      response = json_response(conn, 200)
      assert get_in(response, ["diff", "revealed_cards"]) == ["garage"]
      # After the card is revealed, it should not be in the envelope
      assert get_in(response, ["envelope"]) == []
    end
  end
end
