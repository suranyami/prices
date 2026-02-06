defmodule Prices.Price do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Prices.Coin

  schema "prices" do
    field :price, :decimal
    belongs_to(:coin, Coin)
    timestamps()
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:price])
    |> validate_required([:price])
  end
end
