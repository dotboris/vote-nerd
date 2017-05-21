defmodule VoteNerd.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    children = [
      worker(VoteNerd.Longpoll, []),
      supervisor(VoteNerd.PrivateChat.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
