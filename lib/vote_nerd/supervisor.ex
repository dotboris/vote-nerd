defmodule VoteNerd.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    children = [
      worker(VoteNerd.Longpoll, []),
      supervisor(Supervisor, [
        [
          worker(VoteNerd.Registry, [
            VoteNerd.PrivateChat.Supervisor,
            VoteNerd.Registry
          ]),
          supervisor(VoteNerd.PrivateChat.Supervisor, [
            VoteNerd.PrivateChat.Supervisor
          ])
        ],
        [strategy: :one_for_all]
      ])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
