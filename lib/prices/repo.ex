defmodule Prices.Repo do
  use Ecto.Repo,
    otp_app: :prices,
    adapter: Ecto.Adapters.Postgres
end
