defmodule PricesWeb.Redirect do
  alias Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> Conn.halt()
  end
end
