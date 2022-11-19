defmodule PricesWeb.PricesLive.Index do
  use PricesWeb, :live_view

  alias Prices.{Coins, Prices}

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(PricesWeb.PubSub, "prices")
    {:ok, assign(socket, :coins, get_coins())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_info({:prices, _}, socket) do
    Logger.error("Got a price update")
    {:noreply, assign(socket, :coins, get_coins())}
  end

  def handle_info(_, _state), do: {:noreply, :event_received}

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Crypto Prices")
    |> assign(:coins, get_coins())
  end

  defp get_coins do
    Coins.list()
    |> Enum.map(fn coin ->
      %{
        code: coin.code,
        name: coin.name,
        price: Prices.get_latest_price(coin) || 0
      }
    end)
  end
end
