defmodule VoteNerd.Longpoll do
  @wait_time 60

  def start do
    poll(0)
  end

  defp poll(update_id) do
    Nadia.get_updates(offset: update_id, timeout: @wait_time)
    |> handle_poll(update_id)
  end

  defp handle_poll({:ok, []}, last_update_id) do
    poll(last_update_id)
  end

  defp handle_poll({:ok, updates = [_ | _]}, _) do
    update_id = Enum.reduce(updates, 0, fn (u, _) -> handle_update(u) end)

    poll(update_id + 1)
  end

  defp handle_update(%{message: message, update_id: id}) do
    %{text: text, from: %{username: user}} = message
    IO.puts("#{user}> #{text}")

    id
  end
end
