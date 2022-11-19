defmodule Prices.Coins do
  @moduledoc """
  Functions for creating and fetching Coins.
  """
  import Ecto.Query, warn: false

  alias Prices.{Coin, Repo}

  def get(code) when is_binary(code) do
    Repo.get_by(Coin, code: code)
  end

  def list do
    Repo.all(Coin)
  end

  def create(attrs) do
    %Coin{}
    |> Coin.changeset(attrs)
    |> Repo.insert!()
  end

  def exists?(code) do
    Repo.exists?(from c in Coin, where: c.code == ^code)
  end
end
