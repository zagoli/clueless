defmodule CluelessWeb.PingControllerTest do
  use CluelessWeb.ConnCase, async: true

  describe "GET ping" do
    test "returns 200 with 'pong'", %{conn: conn} do
      conn = get(conn, "/api/ping")
      assert text_response(conn, 200) == "pong"
    end
  end
end
