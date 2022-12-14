defmodule Prices.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Prices.Catalog` context.
  """

  @doc """
  Generate a unique prices sku.
  """
  def unique_product_sku, do: System.unique_integer([:positive])

  @doc """
  Generate a prices.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, prices} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        sku: unique_product_sku(),
        unit_price: 120.5
      })
      |> Prices.Catalog.create_product()

    prices
  end
end
