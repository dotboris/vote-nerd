defmodule VoteNerd.Registry do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def chat(registry, id) do
    GenServer.call(registry, {:chat, id})
  end

  def init(:ok) do
    {:ok, {%{}, %{}}}
  end

  def handle_call({:chat, id}, _from, {pids, refs}) do
    case Map.get(pids, id) do
      nil ->
        {:ok, pid} = VoteNerd.PrivateChat.Supervisor.start_private_chat(id)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, id)
        pids = Map.put(pids, id, pid)
        {:reply, pid, {pids, refs}}
      pid ->
        {:reply, pid, {pids, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {pids, refs}) do
    {id, refs} = Map.pop(refs, ref)
    pids = Map.delete(pids, id)

    {:noreply, {pids, refs}}
  end

  def handle_info(_msg, state), do: {:noreply, state}
end
