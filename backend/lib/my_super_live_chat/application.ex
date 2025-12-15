defmodule MySuperLiveChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    redis_config = Application.get_env(:my_super_live_chat, :redis, [])

    children = [
      MySuperLiveChatWeb.Telemetry,
      MySuperLiveChat.Repo,
      {Redix, host: redis_config[:host], port: redis_config[:port], name: :redix},
      {DNSCluster, query: Application.get_env(:my_super_live_chat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MySuperLiveChat.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MySuperLiveChat.Finch},
      # Start a worker by calling: MySuperLiveChat.Worker.start_link(arg)
      # {MySuperLiveChat.Worker, arg},
      # Start to serve requests, typically the last entry
      MySuperLiveChatWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MySuperLiveChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MySuperLiveChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
