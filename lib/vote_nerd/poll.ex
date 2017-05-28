defmodule VoteNerd.Poll do
  defstruct [:title, options: [], votes: nil]

  @doc """
  Adds option `o` to the `poll`.

  ## Examples

  iex> %VoteNerd.Poll{} |> VoteNerd.Poll.add_option("foobar")
  %VoteNerd.Poll{options: ["foobar"]}

  Note that the options are stored in the inverse order that
  they were added.

  iex> %VoteNerd.Poll{}
  ...> |> VoteNerd.Poll.add_option("a")
  ...> |> VoteNerd.Poll.add_option("b")
  %VoteNerd.Poll{options: ["b", "a"]}
  """
  def add_option(poll, o) do
    poll
    |> Map.update!(:options, &([o | &1]))
  end

  @doc """
  Starts the `poll` allowing people to vote

  ## Examples

  iex> %VoteNerd.Poll{options: ["b", "a"]}
  ...> |> VoteNerd.Poll.start
  %VoteNerd.Poll{
    options: ["b", "a"],
    votes: %{0 => MapSet.new, 1 => MapSet.new}
  }
  """
  def start(%{options: os} = poll) do
    votes = for i <- 0..(length(os) - 1),
      into: %{},
      do: {i, MapSet.new}

    Map.put(poll, :votes, votes)
  end

  @doc """
  Votes as `voter` for the option with the given `index`.

  Note that this acs as a toggle. Voting for something that you've already
  voted for removes your vote.

  ## Examples

  iex> %VoteNerd.Poll{votes: %{0 => MapSet.new}}
  ...> |> VoteNerd.Poll.vote("bob", 0)
  %VoteNerd.Poll{votes: %{0 => MapSet.new(["bob"])}}

  iex> %VoteNerd.Poll{votes: %{0 => MapSet.new}}
  ...> |> VoteNerd.Poll.vote("bob", 0)
  ...> |> VoteNerd.Poll.vote("bob", 0)
  %VoteNerd.Poll{votes: %{0 => MapSet.new()}}

  iex> %VoteNerd.Poll{votes: %{0 => MapSet.new, 1 => MapSet.new}}
  ...> |> VoteNerd.Poll.vote("bob", 0)
  ...> |> VoteNerd.Poll.vote("bob", 1)
  %VoteNerd.Poll{votes: %{0 => MapSet.new(["bob"]), 1 => MapSet.new(["bob"])}}

  iex> %VoteNerd.Poll{votes: %{0 => MapSet.new, 1 => MapSet.new}}
  ...> |> VoteNerd.Poll.vote("bob", 0)
  ...> |> VoteNerd.Poll.vote("bob", 1)
  ...> |> VoteNerd.Poll.vote("bob", 1)
  %VoteNerd.Poll{votes: %{0 => MapSet.new(["bob"]), 1 => MapSet.new}}
  """
  def vote(%{votes: vs} = poll, voter, index) do
    vs = Map.update!(vs, index, fn v ->
      if MapSet.member?(v, voter) do
        MapSet.delete(v, voter)
      else
        MapSet.put(v, voter)
      end
    end)

    Map.put(poll, :votes, vs)
  end
end
