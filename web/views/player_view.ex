defmodule Derviche.PlayerView do
  use Derviche.Web, :view

  def render("index.json", %{players: players}) do
    %{data: render_many(players, Derviche.PlayerView, "player.json")}
  end

  def render("show.json", %{player: player}) do
    %{data: render_one(player, Derviche.PlayerView, "player.json")}
  end

  def render("player.json", %{player: player}) do
    %{id: player.id,
      username: player.username}
  end
end
