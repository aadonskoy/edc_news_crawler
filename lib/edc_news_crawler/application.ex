defmodule EdcNewsCrawler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      EdcNewsCrawler.Repo,
      # Start the Telemetry supervisor
      EdcNewsCrawlerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EdcNewsCrawler.PubSub},
      # Start the Endpoint (http/https)
      EdcNewsCrawlerWeb.Endpoint,
      EdcNewsCrawler.Crawler.Scheduler,
      {EdcNewsCrawler.Crawler.Cache, name: EdcNewsCrawler.CacheNewsApi},
      # Start a worker by calling: EdcNewsCrawler.Worker.start_link(arg)
      # {EdcNewsCrawler.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EdcNewsCrawler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EdcNewsCrawlerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
