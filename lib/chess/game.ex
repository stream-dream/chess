require IEx

defmodule Chess.Game do
  defstruct board: Chess.Board.new,active_player: :white, moves: [], white_captures: [], black_captures: []

  def next_player(active_player) do
    case active_player do
      :white ->
        :black
      :black ->
        :white
    end
  end

  def apply_move(game, move) do
    {white_captures,black_captures} = captures(game,move)

    %Chess.Game{
      board: Chess.Board.apply_move(game.board, move),
      active_player: next_player(game.active_player),
      moves: [game.moves | move],
      white_captures: white_captures,
      black_captures: black_captures
    }
  end

  def captures(game,move) do
    Chess.Board.color_at(game.board, move.to)
    |> case do
      :white ->
        piece = Chess.Board.piece_at(game.board, move.to)
        {game.white_captures,game.black_captures ++ [piece]}
      :black ->
        piece = Chess.Board.piece_at(game.board, move.to)
        {game.white_captures ++ [piece],game.black_captures}
      nil ->
        {game.white_captures,game.black_captures}
    end
  end

  def move(game, {x1, y1}, {x2, y2}) do
    game
    |> Chess.Move.create({x1,y1},{x2,y2})
    |> case do
      {:ok, move} ->
        game = Chess.Game.apply_move(game, move)

        {:ok, game}
      :invalid ->
        {:invalid, game}
    end
  end
end
