defmodule Prices.DatabaseListener.Listener do
  use GenServer
  require Logger

  @doc """
  Initialize the GenServer
  """
  def start_link(channel, otp_opts \\ []), do: GenServer.start_link(__MODULE__, channel, otp_opts)

  @doc """
  When the GenServer starts subscribe to the given channel
  """
  def init(_) do
    Logger.warn("Starting #{__MODULE__} with channel subscription: table_changes")
    pg_config = Prices.Repo.config()
    {:ok, pid} = Postgrex.Notifications.start_link(pg_config)
    {:ok, ref} = Postgrex.Notifications.listen(pid, "table_changes")
    Logger.warn("Started")

    {:ok, {pid, "table_changes", ref}}
  end

  receive do
    params ->
      Logger.warn("Received params: #{inspect(params)}")
  end

  @doc """
  Listen for changes
  """
  def handle_info({:notification, _pid, _ref, _channel, payload}, _state) do
    Logger.warn("Got a notification: #{inspect(payload)}")

    change =
      payload
      |> Jason.decode!()

    # change will decode json into a list with:
    # type - what crud operation it is
    # table - what table it was done on
    # id - the ID of the row, but will also be in the old and new row data
    # new_row_data - the new data either inserted or updated on the row, or nil in case of delete
    # old_row_data - the old data that use to be on the row, or nil in case of insert
    # You can get these with change["type"] for instance and do whatever you want with them below this line
    publish(change)

    {:noreply, :event_handled}
  end

  def handle_info(params, _state) do
    Logger.warn("params: #{inspect(params)}")
    {:noreply, :event_received}
  end

  def publish(change) do
    Logger.info("Publishing change: #{inspect(change)}")
    PubSub.broadcast(PricesWeb.PubSub, :prices, change)
  end

  def publish(_), do: :ok
end
