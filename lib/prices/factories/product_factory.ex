defmodule Prices.ProductFactory do
  alias Prices.Catalog.Product

  defmacro __using__(_opts) do
    quote do
      # Just calling user will give us a new smr

      def product_factory() do
        %Product{
          name: Faker.Commerce.product_name(),
          description: Faker.Lorem.paragraph(),
          unit_price: Faker.Commerce.price(),
          sku: Faker.Util.pick(1..1000_000)
        }
      end
    end
  end
end
