defmodule MySuperLiveChatWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Phoenix.ChannelTest
      import MySuperLiveChatWeb.ChannelCase

      @endpoint MySuperLiveChatWeb.Endpoint
    end
  end

  setup tags do
    MySuperLiveChat.DataCase.setup_sandbox(tags)
    :ok
  end
end
