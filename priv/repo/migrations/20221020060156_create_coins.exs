defmodule Prices.Repo.Migrations.CreateCoins do
  use Ecto.Migration

  def change do
    create table(:coins) do
      add :code, :string, index: true, unique: true
      add :name, :string

      timestamps()
    end
  end
end
