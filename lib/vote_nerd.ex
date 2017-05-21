defmodule VoteNerd do
  use Application

  def start(_type, _args) do
    VoteNerd.Supervisor.start_link
  end
end
