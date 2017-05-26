defmodule VoteNerd.Poll do
  defstruct [:title, options: {}, votes: {}]

  @doc """
  Adds option `o` to the `poll`.

  ## Examples

  iex> %VoteNerd.Poll{} |> VoteNerd.Poll.add_option("foobar")
  %VoteNerd.Poll{options: {"foobar"}, votes: {MapSet.new}}

  iex> %VoteNerd.Poll{}
  ...> |> VoteNerd.Poll.add_option("a")
  ...> |> VoteNerd.Poll.add_option("b")
  %VoteNerd.Poll{options: {"a", "b"}, votes: {MapSet.new, MapSet.new}}
  """
  def add_option(poll, o) do
    poll
    |> Map.update!(:options, &Tuple.append(&1, o))
    |> Map.update!(:votes, &Tuple.append(&1, MapSet.new))
  end
end
