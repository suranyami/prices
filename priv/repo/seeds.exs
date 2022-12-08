# mix run priv/repo/seeds.exs

require Logger

coins = [
  %{
    code: "BTC",
    name: "Bitcoin"
  },
  %{
    code: "LTC",
    name: "LiteCoin"
  },
  %{
    code: "DOGE",
    name: "Dogecoin"
  },
  %{
    code: "ETH",
    name: "Ethereum"
  },
  %{
    code: "XRP",
    name: "Ripple"
  },
  %{
    code: "SOL",
    name: "Solana"
  },
  %{
    code: "XLM",
    name: "Stellar"
  },
  %{
    code: "SHIB",
    name: "Shiba Inu"
  },
  %{
    code: "ADA",
    name: "Cardano"
  },
  %{
    code: "DOT",
    name: "Polkadot"
  },
  %{
    code: "BNB",
    name: "Binance Coin"
  },
  %{
    code: "USDT",
    name: "Tether"
  },
  %{
    code: "UNI",
    name: "Uniswap"
  },
  %{
    code: "LINK",
    name: "Chainlink"
  },
  %{
    code: "BCH",
    name: "Bitcoin Cash"
  },
  %{
    code: "MATIC",
    name: "Polygon"
  },
  %{
    code: "XMR",
    name: "Monero"
  },
  %{
    code: "FIL",
    name: "Filecoin"
  },
  %{
    code: "WBTC",
    name: "Wrapped Bitcoin"
  },
  %{
    code: "THETA",
    name: "Theta"
  },
  %{
    code: "VET",
    name: "VeChain"
  },
  %{
    code: "TRX",
    name: "TRON"
  },
  %{
    code: "LUNA",
    name: "Terra"
  },
  %{
    code: "EOS",
    name: "EOS"
  },
  %{
    code: "AAVE",
    name: "Aave"
  }
]

Enum.each(coins, fn attrs ->
  unless Prices.Coins.exists?(attrs.code) do
    coin = Prices.Coins.create(attrs)
    Logger.info("Created coin #{coin.name}")
    Prices.Prices.update(coin, 100.0)
  end
end)
