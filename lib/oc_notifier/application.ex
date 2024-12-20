defmodule OcNotifier.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OcNotifierWeb.Telemetry,
      OcNotifier.Repo,
      {DNSCluster, query: Application.get_env(:oc_notifier, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OcNotifier.PubSub},
      {Oban, Application.fetch_env!(:oc_notifier, Oban)},
      # Start the Finch HTTP client for sending emails
      {Finch, name: OcNotifier.Finch},
      # Start a worker by calling: OcNotifier.Worker.start_link(arg)
      # {OcNotifier.Worker, arg},
      # Start to serve requests, typically the last entry
      OcNotifierWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OcNotifier.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OcNotifierWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
