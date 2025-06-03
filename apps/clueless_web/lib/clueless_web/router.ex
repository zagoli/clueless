defmodule CluelessWeb.Router do
  use CluelessWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", CluelessWeb do
    pipe_through :api

    get "/ping", PingController, :ping
    post "/new_game", NewGameController, :new_game
    post "/add_card", AddCardController, :add_card
    post "/reveal_card", RevealCardController, :reveal_card
    post "/add_question", AddQuestionController, :add_question
    get "/suggestions", SuggestionsController, :suggestions
  end
end
