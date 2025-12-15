defmodule MySuperLiveChatWeb.RoomChannel do
  use MySuperLiveChatWeb, :channel
  alias MySuperLiveChat.Chat
  require Logger

  @impl true
  def join("room:" <> room_id, _payload, socket) do
    Logger.info("User joining room: #{room_id}")
    send(self(), :after_join)
    {:ok, assign(socket, :room_id, room_id)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    room_id = socket.assigns.room_id
    messages = Chat.list_messages(room_id)

    push(socket, "message_history", %{messages: format_messages(messages)})
    {:noreply, socket}
  end

  @impl true
  def handle_in("new_message", %{"user" => user, "content" => content}, socket) do
    room_id = socket.assigns.room_id

    case Chat.create_message(%{
      user: user,
      content: content,
      room: room_id
    }) do
      {:ok, message} ->
        broadcast!(socket, "new_message", format_message(message))

        cache_message_count(room_id)

        {:reply, {:ok, %{message: format_message(message)}}, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: format_errors(changeset)}}, socket}
    end
  end

  @impl true
  def handle_in("typing", %{"user" => user}, socket) do
    room_id = socket.assigns.room_id
    broadcast_from!(socket, "user_typing", %{user: user, room: room_id})
    {:noreply, socket}
  end

  defp format_messages(messages) do
    Enum.map(messages, &format_message/1)
  end

  defp format_message(message) do
    %{
      id: message.id,
      user: message.user,
      content: message.content,
      room: message.room,
      inserted_at: message.inserted_at
    }
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  defp cache_message_count(room_id) do
    case Redix.command(:redix, ["INCR", "room:#{room_id}:message_count"]) do
      {:ok, _count} -> :ok
      {:error, reason} ->
        Logger.error("Failed to increment message count in Redis: #{inspect(reason)}")
        :ok
    end
  end
end
