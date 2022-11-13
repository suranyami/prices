defmodule Prices.Repo.Migrations.AddPgStatStatements do
  @moduledoc """
  Used by LiveDashboard for detailed Postgres outlier metrics.
  """
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS pg_stat_statements")
  end
end
