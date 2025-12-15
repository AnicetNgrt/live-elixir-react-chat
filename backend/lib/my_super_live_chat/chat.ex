defmodule MySuperLiveChat.Chat do
  import Ecto.Query, warn: false
  alias MySuperLiveChat.Repo
  alias MySuperLiveChat.Chat.Message

  def list_messages(room, limit \\ 50) do
    Message
    |> where([m], m.room == ^room)
    |> order_by([m], desc: m.inserted_at)
    |> limit(^limit)
    |> Repo.all()
    |> Enum.reverse()
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def get_message!(id), do: Repo.get!(Message, id)
end
