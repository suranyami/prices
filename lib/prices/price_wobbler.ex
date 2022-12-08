defmodule Prices.PriceWobbler do
  @moduledoc """
  A GenServer that periodically updates the price of a coin.
  """
  use GenServer
  alias Phoenix.PubSub

  require Logger

  alias Prices.{Coins, Prices}

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: :price_wobbler)
  end

  @doc """
  Load the coins from the database and start moving the prices up and down small percentages.
  """
  @impl true
  def init(_) do
    Logger.debug("Starting #{__MODULE__}")
    prices = Prices.get_price_map()
    Process.send_after(self(), :wobble, Enum.random(10..5000))
    {:ok, prices}
  end

  @impl true
  def handle_info(:wobble, _state) do
    # Logger.debug("Wobbling prices")

    coin =
      Coins.list()
      |> Enum.random()

    wobble_price(coin)
    Process.send_after(self(), :wobble, Enum.random(10..5000))
    {:noreply, Prices.get_price_map()}
  end

  def wobble_price(coin) do
    price = Prices.get_latest_price(coin)

    if price do
      old_price = Decimal.to_float(price.price)
      new_price = old_price + random_percent() * old_price
      Prices.update(coin, new_price)

      change = %{
        code: coin.code,
        price: new_price
      }

      Logger.info("New price of #{coin.name} moved from #{old_price} to #{new_price}")
      PubSub.broadcast(PricesWeb.PubSub, "prices", change)
    else
      Prices.update(coin, 100.0)
    end
  end

  def random_percent do
    Enum.random(-5..5) / (100 * 100)
  end
end
