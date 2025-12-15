defmodule MySuperLiveChat.ChatTest do
  use MySuperLiveChat.DataCase

  alias MySuperLiveChat.Chat

  describe "messages" do
    alias MySuperLiveChat.Chat.Message

    @valid_attrs %{user: "Alice", content: "Hello world", room: "general"}
    @invalid_attrs %{user: nil, content: nil, room: nil}

    test "list_messages/1 returns all messages for a room" do
      message = insert_message(@valid_attrs)
      insert_message(%{@valid_attrs | room: "other"})

      messages = Chat.list_messages("general")
      assert length(messages) == 1
      assert hd(messages).id == message.id
    end

    test "list_messages/2 limits results" do
      for i <- 1..10 do
        insert_message(%{@valid_attrs | content: "Message #{i}"})
      end

      messages = Chat.list_messages("general", 5)
      assert length(messages) == 5
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Chat.create_message(@valid_attrs)
      assert message.user == "Alice"
      assert message.content == "Hello world"
      assert message.room == "general"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_message(@invalid_attrs)
    end

    test "create_message/1 validates content length" do
      long_content = String.duplicate("a", 5001)
      attrs = %{@valid_attrs | content: long_content}
      assert {:error, changeset} = Chat.create_message(attrs)
      assert "should be at most 5000 character(s)" in errors_on(changeset).content
    end

    test "get_message!/1 returns the message with given id" do
      message = insert_message(@valid_attrs)
      assert Chat.get_message!(message.id).id == message.id
    end

    defp insert_message(attrs) do
      {:ok, message} = Chat.create_message(attrs)
      message
    end
  end
end
