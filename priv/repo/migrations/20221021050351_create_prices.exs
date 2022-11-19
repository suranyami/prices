defmodule Prices.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :price, :decimal
      add :coin_id, references(:coins, on_delete: :nothing)

      timestamps()
    end

    create index(:prices, [:coin_id])
  end
end
