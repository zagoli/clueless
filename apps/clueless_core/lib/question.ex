defmodule CluelessCore.Question do
  @moduledoc """
  This module contains the logic for creating and adding questions.
  """

  @doc """
  A question asked by a player in his turn.
  """
  defstruct asked_by: "", answered_by: :nobody, cards: MapSet.new()
end
