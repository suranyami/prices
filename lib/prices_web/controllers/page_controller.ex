defmodule PricesWeb.PageController do
  use PricesWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
