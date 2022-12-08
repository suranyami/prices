defmodule PricesWeb.PricesLive.Index do
  use PricesWeb, :live_view

  alias Prices.{Coins, Prices}
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(PricesWeb.PubSub, "prices")
    {:ok, assign(socket, :coins, get_coins())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(%{code: code, price: price}, socket) do
    Logger.info("Got a price update for #{code} to #{price}")
    coins = update_price(socket.assigns.coins, code, price)
    {:noreply, assign(socket, :coins, coins)}
  end

  def handle_info(payload, socket) do
    Logger.error("Got an unknown message")
    Logger.info(inspect(payload))
    {:noreply, socket}
  end

  def apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Crypto Prices")
    |> assign(:coins, get_coins())
  end

  def get_coins do
    Coins.list()
    |> Enum.reduce(%{}, fn coin, acc ->
      Map.merge(acc, %{
        coin.code => Prices.get_latest_price(coin).price || 0
      })
    end)
  end

  def update_price(map, code, price) do
    Logger.info("Updating price of #{code} to #{price}")

    Map.put(map, :code, price)
  end
end
