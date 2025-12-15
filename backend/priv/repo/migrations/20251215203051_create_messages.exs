defmodule MySuperLiveChat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user, :string, null: false
      add :content, :text, null: false
      add :room, :string, null: false

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:messages, [:room])
    create index(:messages, [:inserted_at])
  end
end
