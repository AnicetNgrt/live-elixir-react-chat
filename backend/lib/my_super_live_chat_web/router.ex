defmodule MySuperLiveChatWeb.Router do
  use MySuperLiveChatWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MySuperLiveChatWeb do
    pipe_through :api
  end
end
