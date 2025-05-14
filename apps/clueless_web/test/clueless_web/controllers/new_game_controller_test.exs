defmodule CluelessWeb.NewGameControllerTest do
  use CluelessWeb.ConnCase, async: true

  describe "POST new_game" do
    test "creates a new game", %{conn: conn} do
      conn = post(conn, ~p"/api/new_game", players: 3)

      assert text_response(conn, 201) == ""
      assert get_session(conn, :game) != nil
    end
  end
end
