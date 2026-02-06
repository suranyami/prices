defmodule Prices.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PricesWeb.Telemetry,
      Prices.Repo,
      {DNSCluster, query: Application.get_env(:prices, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Prices.PubSub},
      Prices.DatabaseListener,
      Prices.PriceWobbler,
      PricesWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Prices.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PricesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
