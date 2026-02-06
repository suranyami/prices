import Config

config :esbuild,
  version: "0.25.4",
  prices: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.12",
  prices: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :prices, Prices.Mailer, adapter: Swoosh.Adapters.Local

config :prices, PricesWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: PricesWeb.ErrorView, json: PricesWeb.ErrorView],
    layout: false
  ],
  pubsub_server: Prices.PubSub,
  live_view: [signing_salt: "7LVG3+3Y"]

config :prices,
  ecto_repos: [Prices.Repo]

config :swoosh, :api_client, false

import_config "#{config_env()}.exs"
