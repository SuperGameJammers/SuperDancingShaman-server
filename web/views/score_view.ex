defmodule Derviche.ScoreView do
  use Derviche.Web, :view

  def render("index.json", %{scores: scores}) do
    %{data: render_many(scores, Derviche.ScoreView, "score.json")}
  end

  def render("show.json", %{score: score}) do
    %{data: render_one(score, Derviche.ScoreView, "score.json")}
  end

  def render("score.json", %{score: score}) do
    %{id: score.id,
      username: score.username,
      score: score.score,
      tribe: score.tribe}
  end
end
