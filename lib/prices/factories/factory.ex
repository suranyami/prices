defmodule Prices.Factory do
  @moduledoc false

  # with Ecto
  use ExMachina.Ecto, repo: Prices.Repo
  use Prices.ProductFactory
end
