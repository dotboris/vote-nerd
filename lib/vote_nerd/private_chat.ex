defmodule VoteNerd.PrivateChat do
  use GenServer

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
      title: nil,
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

    %{state | title: nil, options: [], building: false}
  end

  defp handle_text("/done", %{chat_id: chat_id, building: true, title: title, options: options} = state) do
    buttons = options
    |> Enum.map(fn o -> %Nadia.Model.InlineKeyboardButton{
      text: o,
      url: "http://perdu.com" # TODO: figure out why :callback_data doesn't work
    } end)
    |> Enum.map(fn x -> [x] end)

    Nadia.send_message(
      chat_id,
      "*#{title}*",
      parse_mode: "Markdown",
      reply_markup: %Nadia.Model.InlineKeyboardMarkup{
        inline_keyboard: buttons
      }
    )

    %{state | title: nil, options: [], building: false}
  end

  defp handle_text(title, %{chat_id: chat_id, building: true, title: nil} = state) do
    Nadia.send_message(chat_id, "OK. Now start typing some options.")

    %{state | title: title}
  end

  defp handle_text(option, %{chat_id: chat_id, building: true, options: options, title: title} = state) when is_binary(title) do
    Nadia.send_message(chat_id, "OK. Type in another option. If you're done use /done")

    %{state | options: options ++ [option]}
  end

  defp handle_text(_text, %{chat_id: chat_id} = state) do
    Nadia.send_message(chat_id, "Huh?")

    state
  end
end
