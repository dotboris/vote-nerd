defmodule VoteNerd.Longpoll do
  @wait_time 60

  def start_link do
    pid = spawn_link(fn () -> poll(0) end)
    Process.register(pid, __MODULE__)
    {:ok, pid}
  end

  defp poll(update_id) do
    [offset: update_id, timeout: @wait_time]
    |> Nadia.get_updates
    |> handle_poll(update_id)
    |> poll
  end

  defp handle_poll({:ok, []}, last_update_id), do: last_update_id

  defp handle_poll({:ok, updates}, _) do
    update_id = Enum.reduce(updates, 0, fn (u, _) -> handle_update(u) end)

    update_id + 1
  end

  defp handle_update(%{update_id: update_id} = update) do
    spawn(VoteNerd.Router, :dispatch, [update])

    update_id
  end
end
