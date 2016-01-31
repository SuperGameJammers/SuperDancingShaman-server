defmodule Derviche.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :username, :integer

      timestamps
    end

  end
end
