defmodule VoteNerd.Router do
  alias VoteNerd.{Registry, PrivateChat}

  def dispatch(%{message: %{chat: %{type: "private", id: chat_id}}} = update) do
    Registry
    |> Registry.chat(chat_id)
    |> PrivateChat.update(update)
  end

  def dispatch(_) do
    # do nothing
  end
end
