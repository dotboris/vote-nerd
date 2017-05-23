defmodule VoteNerd.Registry do
  use GenServer

  alias VoteNerd.PrivateChat.Supervisor

  @doc """
  Starts the registry where `supervisor` is the pid of the
  `VoteNerd.PrivateChat.Supervisor` used to spawn chat processes and `name` is
  the name of the process.
  """
  def start_link(supervisor, name) do
    GenServer.start_link(__MODULE__, supervisor, name: name)
  end

  def chat(registry, id) do
    GenServer.call(registry, {:chat, id})
  end

  def init(supervisor) do
    {:ok, {supervisor, %{}, %{}}}
  end

  def handle_call({:chat, id}, _from, {supervisor, pids, refs} = state) do
    case Map.get(pids, id) do
      nil ->
        {:ok, pid} = Supervisor.start_private_chat(supervisor, id)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, id)
        pids = Map.put(pids, id, pid)
        {:reply, pid, {supervisor, pids, refs}}
      pid ->
        {:reply, pid, state}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {supervisor, pids, refs}) do
    {id, refs} = Map.pop(refs, ref)
    pids = Map.delete(pids, id)

    {:noreply, {supervisor, pids, refs}}
  end

  def handle_info(_msg, state), do: {:noreply, state}
end
