defmodule PricesWeb.PageController do
  use PricesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
