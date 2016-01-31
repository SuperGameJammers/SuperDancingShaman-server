defmodule Derviche.Repo.Migrations.CreateScore do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :username, :string
      add :score, :integer
      add :tribe, :string

      timestamps
    end

  end
end
