defmodule Clueless.Player do
  @moduledoc """
  Clue game players. Only the number of players is stored in the game state.
  Players are represented by their number: the first player is 0, the second player is 1, and so on.
  """

  @doc """
  Returns the indices of the players between two players in a circular list. Extremes are excluded.

  ## Examples

      iex> players_between(3, 0, 2)
      [1]

      iex> players_between(3, 0, 2)
      [1]

      iex> players_between(3, 2, 1)
      [0]

      iex> players_between(3, 2, 0)
      []

      iex> players_between(3, 0, 0)
      [1, 2]

      iex> players_between(3, 0, 1)
      []

      iex> players_between(3, 0, 3)
      []

      iex> players_between(3, -1, 4)
      []
  """

  def players_between(_players_number, start_player, end_player)
      when is_nil(start_player) or is_nil(end_player) do
    []
  end

  def players_between(players_number, start_player, end_player)
      when is_integer(players_number) and is_integer(start_player) and is_integer(end_player) do
    players_size = players_number - 1

    cond do
      start_player < 0 or end_player < 0 ->
        []

      start_player > players_size or end_player > players_size ->
        []

      true ->
        generate_players_between(start_player, end_player, players_size)
    end
  end

  defp generate_players_between(start_player, end_player, players_size)
       when start_player == end_player,
       do: Enum.to_list(0..players_size) -- [start_player]

  defp generate_players_between(start_player, end_player, _players_size)
       when start_player < end_player,
       do: Enum.to_list(start_player..end_player) -- [start_player, end_player]

  defp generate_players_between(start_player, end_player, players_size)
       when start_player > end_player,
       do:
         (Enum.to_list(0..end_player) ++ Enum.to_list(start_player..players_size)) --
           [start_player, end_player]

  @doc """
  Returns a list of all players in the game.

  ## Examples

      iex> all_players(3)
      [0, 1, 2]

      iex> all_players(5)
      [0, 1, 2, 3, 4]
  """
  def all_players(players_number)
      when is_integer(players_number) and players_number > 0 do
    Enum.to_list(0..(players_number - 1))
  end
end
