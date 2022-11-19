defmodule Prices.Prices do
  @moduledoc """
  Functions for creating and fetching Prices.
  """

  import Ecto.Query, warn: false
  alias Prices.{Coin, Coins, Price, Repo}

  def get(id) do
    Repo.get(Price, id)
  end

  def get_latest_price(coin = %Coin{}) do
    Repo.one(
      from p in Price,
        where: p.coin_id == ^coin.id,
        order_by: [desc: p.inserted_at],
        limit: 1
    )
  end

  def get_latest_price(code) when is_binary(code) do
    code
    |> Coins.get()
    |> get_latest_price()
  end

  def update(coin = %Coin{}, price) do
    Repo.insert!(%Price{coin_id: coin.id, price: price})
  end

  def get_price_map do
    Coins.list()
    |> Enum.reduce(%{}, fn coin, accumulator ->
      Map.put(accumulator, coin.code, %{name: coin.name, price: get_latest_price(coin) || 0})
    end)
  end

  def format(price) do
    "$#{Decimal.round(price, 2)}"
  end
end
