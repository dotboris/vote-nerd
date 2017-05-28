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
end
