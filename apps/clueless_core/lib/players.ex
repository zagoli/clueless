defmodule CluelessCore.Players do
  @moduledoc """
  Clue game players. Only the player name is relevant for the game.
  """

  @doc """
  Returns the player index in the list of players.

  ## Examples

      iex> get_player_index(["Alice", "Bob", "Charlie"], "Bob")
      1

      iex> get_player_index(["Alice", "Bob", "Charlie"], "Dave")
      nil

  """
  def get_player_index(players, player) when is_binary(player) and is_list(players),
    do: Enum.find_index(players, &(&1 == player))

  @doc """
  Returns the indices of the players between two players in a circular list. Extremes are excluded.

  ## Examples

      iex> players_between(["Alice", "Bob", "Charlie"], "Alice", "Charlie")
      [1]

      iex> players_between(["Alice", "Bob", "Charlie"], 0, 2)
      [1]

      iex> players_between(["Alice", "Bob", "Charlie"], "Charlie", "Bob")
      [0]

      iex> players_between(["Alice", "Bob", "Charlie"], "Charlie", "Alice")
      []

      iex> players_between(["Alice", "Bob", "Charlie"], "Alice", "Alice")
      [1, 2]

      iex> players_between(["Alice", "Bob", "Charlie"], "Alice", "Bob")
      []

      iex> players_between(["Alice", "Bob", "Charlie"], "Alice", "Dave")
      []

      iex> players_between(["Alice", "Bob", "Charlie"], -1, 4)
      []
  """
  def players_between(players, start_player, end_player)
      when is_list(players) and is_binary(start_player) and is_binary(end_player) do
    start_index = get_player_index(players, start_player)
    end_index = get_player_index(players, end_player)
    players_between(players, start_index, end_index)
  end

  def players_between(_players, start_player, end_player)
      when is_nil(start_player) or is_nil(end_player) do
    []
  end

  def players_between(players, start_player, end_player)
      when is_list(players) do
    players_size = Enum.count(players) - 1

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
end
