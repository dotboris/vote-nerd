defmodule VoteNerd.PrivateChat do
  use GenServer

  alias VoteNerd.Poll
  alias Nadia.Model.{InlineKeyboardButton, InlineKeyboardMarkup}

  @help_text """
  /start Create a new poll
  /cancel Cancel building a poll
  /help Show this text
  """

  def start_link(chat_id) do
    GenServer.start_link(__MODULE__, chat_id)
  end

  def update(pid, update) do
    GenServer.cast(pid, {:update, update})
  end

  def init(chat_id) do
    {:ok, %{
      chat_id: chat_id,
      building: false,
      poll: %Poll{}
    }}
  end

  def handle_cast({:update, update}, state) do
    %{message: %{text: text}} = update
    state = handle_text(text, state)

    {:noreply, state}
  end

  defp handle_text("/help", %{chat_id: chat_id} = state) do
    Nadia.send_message(chat_id, @help_text)

    state
  end

  defp handle_text("/start", %{chat_id: chat_id, building: true} = state) do
    Nadia.send_message(chat_id,
      "We're already creating a poll. Use /cancel to reset everything."
    )

    state
  end

  defp handle_text("/start", %{chat_id: chat_id, building: false} = state) do
    Nadia.send_message(chat_id,
      "OK. Let's get started. What would you like to name your poll?"
    )

    %{state | building: true}
  end

  defp handle_text("/cancel", %{chat_id: chat_id} = state) do
    Nadia.send_message(chat_id, "OK. I reset everything.")

    %{state | building: false, poll: %Poll{}}
  end

  defp handle_text("/done",
    %{
      chat_id: chat_id,
      building: true,
      poll: poll
    } = state
  ) do
    buttons = poll.options
    |> Enum.with_index
    |> Enum.map(fn {o, i} -> %InlineKeyboardButton{
      text: o,
      callback_data: Integer.to_string(i)
    } end)
    |> Enum.map(fn x -> [x] end)
    |> Enum.reverse

    share_button = [%InlineKeyboardButton{
      text: "Share",
      switch_inline_query: ""
    }]

    Nadia.send_message(
      chat_id,
      "*#{poll.title}*",
      parse_mode: "Markdown",
      reply_markup: %InlineKeyboardMarkup{
        inline_keyboard: [share_button | buttons]
      }
    )

    %{state | poll: %Poll{}, building: false}
  end

  defp handle_text(title,
    %{
      chat_id: chat_id,
      building: true,
      poll: %{title: nil} = poll
    } = state
  ) do
    Nadia.send_message(chat_id, "OK. Now start typing some options.")

    %{state | poll: Map.put(poll, :title, title)}
  end

  defp handle_text(option,
    %{
      chat_id: chat_id,
      building: true,
      poll: poll
    } = state
  ) do
    Nadia.send_message(chat_id, "OK. Type in another option. If you're done use /done")

    %{state | poll: Poll.add_option(poll, option)}
  end

  defp handle_text(_text, %{chat_id: chat_id} = state) do
    Nadia.send_message(chat_id, "Huh?")

    state
  end
end
