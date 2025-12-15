defmodule MySuperLiveChat.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :user, :string
    field :content, :string
    field :room, :string

    timestamps(type: :utc_datetime, updated_at: false)
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user, :content, :room])
    |> validate_required([:user, :content, :room])
    |> validate_length(:content, min: 1, max: 5000)
    |> validate_length(:user, min: 1, max: 50)
  end
end
