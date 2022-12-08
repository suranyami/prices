defmodule Prices.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Prices.Repo,
      PricesWeb.Telemetry,
      {Prices.PriceWobbler, []},
      PricesWeb.Endpoint,
      {Phoenix.PubSub, name: PricesWeb.PubSub},
      {Postgrex.Notifications, Keyword.put_new(Prices.Repo.config(), :name, PricesWeb.Notifier)},
      {Prices.DatabaseListener, "table_changes"}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Prices.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PricesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
