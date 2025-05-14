defmodule CluelessWeb.AddCardControllerTest do
  use CluelessWeb.ConnCase, async: true

  defp create_game(%{conn: conn}) do
    conn = post(conn, ~p"/api/new_game", players: 3)
    %{conn: conn}
  end

  describe "POST add_card" do
    setup [:create_game]

    test "adds a card to a player", %{conn: conn} do
      conn = post(conn, ~p"/api/add_card", card: "garage", player: 0)

      response = json_response(conn, 200)
      assert get_in(response, ["diff", "hands", "0"]) == ["garage"]
      assert get_in(response, ["diff", "absent_cards", "1"]) == ["garage"]
      assert get_in(response, ["diff", "absent_cards", "2"]) == ["garage"]
    end

    test "only returns the difference, but game state contains all cards", %{conn: conn} do
      conn =
        conn
        |> post(~p"/api/add_card", card: "garage", player: 0)
        |> post(~p"/api/add_card", card: "kitchen", player: 1)

      response = json_response(conn, 200)
      assert get_in(response, ["diff", "hands", "1"]) == ["kitchen"]
      assert get_in(response, ["diff", "absent_cards", "0"]) == ["kitchen"]
      assert get_in(response, ["diff", "absent_cards", "2"]) == ["kitchen"]

      game = get_session(conn, :game)
      assert game.hands[0] |> Enum.to_list() == ["garage"]
      assert game.hands[1] |> Enum.to_list() == ["kitchen"]
    end
  end
end
