defmodule PricesWeb.PricesLiveTest do
  use PricesWeb.ConnCase

  import Phoenix.LiveViewTest
  import Prices.CatalogFixtures

  @create_attrs %{description: "some description", name: "some name", sku: 42, unit_price: 120.5}
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    sku: 43,
    unit_price: 456.7
  }
  @invalid_attrs %{description: nil, name: nil, sku: nil, unit_price: nil}

  defp create_product(_) do
    prices = product_fixture()
    %{prices: prices}
  end

  describe "Index" do
    setup [:create_product]

    test "lists all products", %{conn: conn, prices: prices} do
      {:ok, _index_live, html} = live(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Listing Products"
      assert html =~ prices.description
    end

    test "saves new prices", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("a", "New Prices") |> render_click() =~
               "New Prices"

      assert_patch(index_live, Routes.product_index_path(conn, :new))

      assert index_live
             |> form("#prices-form", prices: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#prices-form", prices: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Prices created successfully"
      assert html =~ "some description"
    end

    test "updates prices in listing", %{conn: conn, prices: prices} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#prices-#{prices.id} a", "Edit") |> render_click() =~
               "Edit Prices"

      assert_patch(index_live, Routes.product_index_path(conn, :edit, prices))

      assert index_live
             |> form("#prices-form", prices: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#prices-form", prices: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Prices updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes prices in listing", %{conn: conn, prices: prices} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#prices-#{prices.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#prices-#{prices.id}")
    end
  end

  describe "Show" do
    setup [:create_product]

    test "displays prices", %{conn: conn, prices: prices} do
      {:ok, _show_live, html} = live(conn, Routes.product_show_path(conn, :show, prices))

      assert html =~ "Show Prices"
      assert html =~ prices.description
    end

    test "updates prices within modal", %{conn: conn, prices: prices} do
      {:ok, show_live, _html} = live(conn, Routes.product_show_path(conn, :show, prices))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Prices"

      assert_patch(show_live, Routes.product_show_path(conn, :edit, prices))

      assert show_live
             |> form("#prices-form", prices: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#prices-form", prices: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_show_path(conn, :show, prices))

      assert html =~ "Prices updated successfully"
      assert html =~ "some updated description"
    end
  end
end
