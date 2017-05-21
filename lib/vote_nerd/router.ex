defmodule VoteNerd.Router do
  alias VoteNerd.{Registry, PrivateChat}

  def dispatch(%{message: %{chat: %{type: "private", id: chat_id}}} = update) do
    IO.puts("Matched private chat #{chat_id}")
    Registry.chat(Registry, chat_id)
    |> PrivateChat.update(update)
  end

  def dispatch(update) do
    IO.puts("Unmatched update :(")
    IO.inspect(update)
  end
end
