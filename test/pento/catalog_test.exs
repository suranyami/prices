defmodule Prices.CatalogTest do
  use Prices.DataCase

  alias Prices.Catalog

  describe "products" do
    import Prices.Catalog.Prices.CatalogFixtures

    alias Prices.Catalog.Prices

    @invalid_attrs %{description: nil, name: nil, sku: nil, unit_price: nil}

    test "list_products/0 returns all products" do
      prices = product_fixture()
      assert Catalog.list_products() == [prices]
    end

    test "get_product!/1 returns the prices with given id" do
      prices = product_fixture()
      assert Catalog.get_product!(prices.id) == prices
    end

    test "create_product/1 with valid data creates a prices" do
      valid_attrs = %{
        description: "some description",
        name: "some name",
        sku: 42,
        unit_price: 120.5
      }

      assert {:ok, %Prices{} = prices} = Catalog.create_product(valid_attrs)
      assert prices.description == "some description"
      assert prices.name == "some name"
      assert prices.sku == 42
      assert prices.unit_price == 120.5
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the prices" do
      prices = product_fixture()

      update_attrs = %{
        description: "some updated description",
        name: "some updated name",
        sku: 43,
        unit_price: 456.7
      }

      assert {:ok, %Prices{} = prices} = Catalog.update_product(prices, update_attrs)
      assert prices.description == "some updated description"
      assert prices.name == "some updated name"
      assert prices.sku == 43
      assert prices.unit_price == 456.7
    end

    test "update_product/2 with invalid data returns error changeset" do
      prices = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(prices, @invalid_attrs)
      assert prices == Catalog.get_product!(prices.id)
    end

    test "delete_product/1 deletes the prices" do
      prices = product_fixture()
      assert {:ok, %Prices{}} = Catalog.delete_product(prices)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(prices.id) end
    end

    test "change_product/1 returns a prices changeset" do
      prices = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(prices)
    end
  end
end
