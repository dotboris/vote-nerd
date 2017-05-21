defmodule VoteNerd.PrivateChat do
  use GenServer

  def start_link(chat_id) do
    GenServer.start_link(__MODULE__, chat_id)
  end

  def update(pid, update) do
    GenServer.cast(pid, {:update, update})
  end

  def init(chat_id) do
    {:ok, %{
      chat_id: chat_id,
      title: "",
      options: [],
      building: false
    }}
  end

  def handle_cast({:update, update}, state) do
    %{message: %{text: text}} = update
    state = handle_text(text, state)

    {:noreply, state}
  end

  defp handle_text("/help", %{chat_id: chat_id} = state) do
    Nadia.send_message(chat_id, "TODO: write /help")

    state
  end

  defp handle_text(_text, %{chat_id: chat_id} = state) do
    Nadia.send_message(chat_id, "Huh?")

    state
  end
end
