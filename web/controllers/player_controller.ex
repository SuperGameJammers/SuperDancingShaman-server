defmodule Derviche.PlayerController do
  use Derviche.Web, :controller

  alias Derviche.Player
  alias Derviche.Keys

  ExFirebase.set_url(Keys.Firebase_url)

  plug :scrub_params, "player" when action in [:create, :update]

  def highscores(conn, _) do
    scores = ExFirebase.get()
    render(conn, "index.json", scores: scores)
  end

  defp parse_scores(scores) do
    case JSX.decode(scores) do
      {:ok, scores} ->
        scores
      {:error, reason} ->
        text(conn, "Something weird happened! Error: #{reason}")
      :else ->
        text(conn, "Something extremely weird happened!")
    end
  end

  def calculate_highscores(scores) do
    highscores = []
    ordered_scores = []
    for n <- 0..4 do
      ordered_scores = Enum.into(ordered_scores, [Enum.max_by(scores, fn(x) -> x end)])
      IO.puts "Primero #{inspect ordered_scores}"
      [max_score|_] = ordered_scores
      IO.puts "2do #{inspect max_score}"
      highscores = Enum.into(highscores, [max_score])
      IO.puts "3ro #{inspect highscores}"
      {to_delete, _} = Enum.fetch!(highscores, n)
      IO.puts "4to #{inspect to_delete}"
      scores = Map.drop(scores, [to_delete])
      IO.puts "5to #{inspect scores}"
    end
  end

  def index(conn, _params) do
    players = Repo.all(Player)
    render(conn, "index.json", players: players)
  end

  def create(conn, %{"player" => player_params}) do
    changeset = Player.changeset(%Player{}, player_params)

    case Repo.insert(changeset) do
      {:ok, player} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", player_path(conn, :show, player))
        |> render("show.json", player: player)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Derviche.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    player = Repo.get!(Player, id)
    render(conn, "show.json", player: player)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Repo.get!(Player, id)
    changeset = Player.changeset(player, player_params)

    case Repo.update(changeset) do
      {:ok, player} ->
        render(conn, "show.json", player: player)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Derviche.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Repo.get!(Player, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(player)

    send_resp(conn, :no_content, "")
  end
end
