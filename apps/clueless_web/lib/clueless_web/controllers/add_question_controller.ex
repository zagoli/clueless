defmodule CluelessWeb.AddQuestionController do
  use CluelessWeb, :controller
  alias Clueless.Question

  plug :put_view, CluelessWeb.ClueGameHintsJson

  def add_question(conn, %{"asked_by" => asked_by, "answered_by" => answered_by, "cards" => cards})
      when is_integer(asked_by) and is_number(answered_by) and is_list(cards) do
    old_game = get_session(conn, :game)

    question = %Question{
      asked_by: asked_by,
      answered_by: if(answered_by == -1, do: :nobody, else: answered_by),
      cards: MapSet.new(cards)
    }

    new_game = Question.add_question(old_game, question)

    conn
    |> put_session(:game, new_game)
    |> assign(:old_game, old_game)
    |> assign(:new_game, new_game)
    |> render(:clue_game_hints)
  end
end
