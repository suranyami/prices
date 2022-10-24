defmodule Pento.Factory do
  @moduledoc false

  # with Ecto
  use ExMachina.Ecto, repo: Pento.Repo
  use Pento.ProductFactory
end
