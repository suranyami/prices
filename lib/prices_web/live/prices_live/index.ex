defmodule PricesWeb.PricesLive.Index do
  @moduledoc false
  use PricesWeb, :live_view

  alias Phoenix.PubSub
  alias Prices.Coins

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    :ok = PubSub.subscribe(Prices.PubSub, "price_change")
    {:ok, socket
    |> stream(:coins, get_coins())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(payload = %{
    "id" => _,
    "new_row_data" => _,
    "old_row_data" => _
    }, socket) do
    Logger.info(inspect(payload))

    {:noreply, stream(socket, :coins, updated_coin(payload))}
  end

  def handle_info(something, socket) do
    Logger.error("Got an unknown message: #{inspect(something)}")
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Crypto Prices")
    |> assign(:coins, get_coins())
  end

  defp get_coins do
    Enum.map(Coins.list(), fn coin ->
      latest = Prices.Prices.get_latest_price(coin)
      price_value = if latest, do: latest.price, else: Decimal.new(0)

      %{
        id: coin.id,
        code: coin.code,
        name: coin.name,
        price_display: Prices.Prices.format(price_value),
        diff: diff_symbol(0)
      }
    end)
  end

  defp updated_coin(payload = %{
    "id" => id,
    "new_row_data" => %{
      "coin_id" => coin_id,
       "price" => price
      },
      "old_row_data" => %{
        "price" => old_price
      }
    }) do
      coin = Coins.get(coin_id)
      Logger.info("Updated coin: #{coin.name}")
      Logger.info("New price: #{price}")
      Logger.info("Old price: #{old_price}")
      difference = Prices.Prices.last_price_movement(coin)
      Logger.info("Diff: #{difference}")
      diff_sym = diff_symbol(difference)
      Logger.info("Diff symbol: #{diff_sym}")
      [
        %{
        id: coin_id,
        code: coin.code,
        name: coin.name,
        price_display: Prices.Prices.format(Decimal.from_float(price)),
        diff: diff_sym
      }
    ]
  end

  defp diff_symbol(difference) when difference > 0.0, do: "⇧"
  defp diff_symbol(difference) when difference < 0.0, do: "▼"
  defp diff_symbol(_), do: " "

end
