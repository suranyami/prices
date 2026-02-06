defmodule Prices.Prices do
  @moduledoc """
  Functions for creating and fetching Prices.
  """

  import Ecto.Query, warn: false

  alias Prices.Coin
  alias Prices.Coins
  alias Prices.Price
  alias Prices.Repo

  def get(id) do
    Repo.get(Price, id)
  end

  def last_price_movement(%Coin{} = coin) do
    coin
    |> get_last_2_prices()
    |> calc_price_movement()
  end

  def calc_price_movement([price1, price2]) do
    difference = Decimal.to_float(price1.price) - Decimal.to_float(price2.price)
    difference
  end

  def calc_price_movement(_) do
    0.0
  end

  def get_last_2_prices(coin) do
    Repo.all(
      from p in Price,
        where: p.coin_id == ^coin.id,
        order_by: [desc: p.inserted_at],
        limit: ^2
    )
  end
  def get_latest_price(%Coin{} = coin) do
    Repo.one(
      from p in Price,
        where: p.coin_id == ^coin.id,
        order_by: [desc: p.inserted_at],
        limit: ^1
    )
  end

  def get_latest_price(code) when is_binary(code) do
    code
    |> Coins.get()
    |> get_latest_price()
  end

  def update(%Coin{} = coin, price) do
    Repo.insert!(%Price{coin_id: coin.id, price: price})
  end

  def get_price_map do
    Enum.reduce(Coins.list(), %{}, fn coin, accumulator ->
      Map.put(accumulator, coin.code, %{name: coin.name, price: get_latest_price(coin) || 0})
    end)
  end

  def format(price) do
    "$#{Decimal.round(price, 2)}"
  end
end
