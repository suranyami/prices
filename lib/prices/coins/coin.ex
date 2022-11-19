defmodule Prices.Coin do
  use Ecto.Schema
  import Ecto.Changeset
  alias Prices.Price

  schema "coins" do
    field :code, :string
    field :name, :string
    has_many :prices, Price

    timestamps()
  end

  @required ~w(code name)a
  @optional ~w()a
  def changeset(coin, attrs) do
    coin
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> unique_constraint(:code)
  end
end
