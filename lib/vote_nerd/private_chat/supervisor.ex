defmodule VoteNerd.PrivateChat.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(_) do
    children = [
      worker(VoteNerd.PrivateChat, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_private_chat(chat_id) do
    Supervisor.start_child(__MODULE__, [chat_id])
  end
end
