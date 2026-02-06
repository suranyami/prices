defmodule Mix.Tasks.Sample do
  @shortdoc "Creates sample products"
  @moduledoc false
  use Mix.Task

  import Prices.Factory

  alias Prices.Repo

  def run(_) do
    Enum.each([:postgrex, :ecto, :ex_machina], &Application.ensure_all_started/1)
    Repo.start_link()

    Enum.each(1..100, fn _ ->
      prices = insert(:prices)
      IO.puts("Created prices: #{prices.name}")
    end)
  end
end
