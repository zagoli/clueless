defmodule CluelessCore.Question do
  @moduledoc """
  This module contains the logic for creating and adding questions.
  """

  @doc """
  A question asked by a player in his turn.
  asked_by: the name of the player who asked the question
  answered_by: the name of the player who answered the question or :nobody
  cards: a %MapSet{} of cards that were asked
  """
  defstruct asked_by: "", answered_by: :nobody, cards: MapSet.new()
end
