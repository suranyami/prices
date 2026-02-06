defmodule Prices.DatabaseListener do
  @moduledoc false
  use GenServer

  alias Prices.Repo

  require Logger
  alias Phoenix.PubSub

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  @doc """
  Initialize the GenServer
  """
  def start_link(args) do
    Logger.debug("DatabaseListener starting")
    GenServer.start_link(__MODULE__, [args], name: __MODULE__)
  end

  @channel "table_changes"

  @doc """
  When the GenServer starts subscribe to the given channel
  """
  def init(_args) do
    Logger.warning("Starting #{__MODULE__} with channel subscription: #{@channel}")

    repo_config = Repo.config()

    {:ok, pid} = Postgrex.Notifications.start_link(repo_config)
    {:ok, ref} = Postgrex.Notifications.listen(pid, @channel)

    Logger.warning("Started DatabaseListener")

    {:ok, {pid, ref}}
  end

  @doc """
  Listen for changes
  """
  def handle_info({:notification, _pid, _ref, @channel, payload}, state) do
    payload = Jason.decode!(payload)

    # IO.inspect(payload)

    publish(payload)

    {:noreply, state}
  end

  def handle_info(params, state) do
    Logger.error("params: #{inspect(params)}")
    {:noreply, state}
  end

  def publish(payload) do
    # Logger.info("Publishing change: #{inspect(payload)}")
    PubSub.broadcast(Prices.PubSub, "price_change", payload)
  end
end
