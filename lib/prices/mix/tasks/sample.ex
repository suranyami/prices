defmodule Mix.Tasks.Sample do
  @moduledoc false
  use Mix.Task
  import Prices.Factory
  alias Prices.Repo

  @shortdoc "Creates sample products"
  def run(_) do
    [:postgrex, :ecto, :ex_machina]
    |> Enum.each(&Application.ensure_all_started/1)

    Repo.start_link()

    1..100
    |> Enum.each(fn _ ->
      prices = insert(:prices)
      IO.puts("Created prices: #{prices.name}")
    end)
  end
end
