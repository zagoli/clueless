defmodule CluelessWeb.PingController do
  use CluelessWeb, :controller

  def ping(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "pong")
  end
end
