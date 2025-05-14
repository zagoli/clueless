defmodule CluelessWeb.Router do
  use CluelessWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CluelessWeb do
    pipe_through :api

    post "/new_game", NewGameController, :new_game
  end
end
