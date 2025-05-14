defmodule CluelessWeb.GameFixtures do
  use CluelessWeb, :verified_routes
  import Phoenix.ConnTest

  def create_game(%{conn: conn}) do
    conn = post(conn, ~p"/api/new_game", players: 3)
    %{conn: conn}
  end
end
