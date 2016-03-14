defmodule Chess.Piece.Rook do
  def move_definitions(board, color) do
    [
      fn({x1,y1}) ->
        x2 = x1
        (y1+1)..Chess.Board.max_y
        |> Enum.reduce_while([], fn(y2,acc) ->
          reduce_move_while(acc, board, {x2,y2})
        end)
      end,
      fn({x1,y1}) ->
        x2 = x1
        (y1-1)..Chess.Board.min_y
        |> Enum.reduce_while([], fn(y2,acc) ->
          reduce_move_while(acc, board, {x2,y2})
        end)
      end,
      fn({x1,y1}) ->
        y2 = y1
        (x1+1)..Chess.Board.max_x
        |> Enum.reduce_while([], fn(x2,acc) ->
          reduce_move_while(acc, board, {x2,y2})
        end)
      end,
      fn({x1,y1}) ->
        y2 = y1
        (x1-1)..Chess.Board.min_x
        |> Enum.reduce_while([], fn(x2,acc) ->
          reduce_move_while(acc, board, {x2,y2})
        end)
      end
    ]
  end

  defp reduce_move_while(acc, board, {x2,y2}) do
    board
    |> Chess.Board.color_at({x2,y2})
    |> case do
       nil ->
         {:cont, Enum.concat(acc, [{x2,y2}])}
       :black ->
         {:halt, Enum.concat(acc, [{x2,y2}])}
       :white ->
         {:halt, acc}
       end
  end
end