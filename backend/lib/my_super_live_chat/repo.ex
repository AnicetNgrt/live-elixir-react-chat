defmodule MySuperLiveChat.Repo do
  use Ecto.Repo,
    otp_app: :my_super_live_chat,
    adapter: Ecto.Adapters.Postgres
end
