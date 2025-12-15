defmodule MySuperLiveChatWeb.RoomChannelTest do
  use MySuperLiveChatWeb.ChannelCase

  alias MySuperLiveChat.Chat

  setup do
    {:ok, _, socket} =
      MySuperLiveChatWeb.UserSocket
      |> socket("user_id", %{})
      |> subscribe_and_join(MySuperLiveChatWeb.RoomChannel, "room:lobby")

    %{socket: socket}
  end

  test "join sends message history", %{socket: socket} do
    Chat.create_message(%{user: "Alice", content: "Hello", room: "lobby"})
    Chat.create_message(%{user: "Bob", content: "Hi", room: "lobby"})

    {:ok, _, new_socket} =
      MySuperLiveChatWeb.UserSocket
      |> socket("user_id", %{})
      |> subscribe_and_join(MySuperLiveChatWeb.RoomChannel, "room:lobby")

    assert_push "message_history", %{messages: messages}
    assert length(messages) == 2
    assert new_socket.assigns.room_id == "lobby"
  end

  test "new_message broadcasts to room:lobby", %{socket: socket} do
    push(socket, "new_message", %{user: "Alice", content: "Hello everyone"})
    assert_broadcast "new_message", %{user: "Alice", content: "Hello everyone"}
  end

  test "new_message creates message in database", %{socket: socket} do
    push(socket, "new_message", %{user: "Alice", content: "Test message"})

    messages = Chat.list_messages("lobby")
    assert length(messages) == 1
    assert hd(messages).content == "Test message"
  end

  test "new_message with invalid data returns error", %{socket: socket} do
    ref = push(socket, "new_message", %{user: "", content: ""})
    assert_reply ref, :error, %{errors: _}
  end

  test "typing broadcasts to room:lobby", %{socket: socket} do
    broadcast_from!(socket, "typing", %{user: "Alice"})
    assert_broadcast "user_typing", %{user: "Alice", room: "lobby"}
  end
end
