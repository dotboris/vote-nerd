defmodule VoteNerd.PrivateChat.Supervisor do
  use Supervisor

  def start_link(name) do
    Supervisor.start_link(__MODULE__, :ok, [name: name])
  end

  def init(_) do
    children = [
      worker(VoteNerd.PrivateChat, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_private_chat(supervisor, chat_id) do
    Supervisor.start_child(supervisor, [chat_id])
  end
end
