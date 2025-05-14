defmodule CluelessWeb.SuggestionsJSON do
  def suggestions(assigns) do
    %{cards_suspect_score: assigns.cards_suspect_score |> Enum.into(%{})}
  end
end
