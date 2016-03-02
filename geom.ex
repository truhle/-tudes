defmodule Geom do
  @moduledoc """
  Functions calculating gemoetric values.
  """

  # @doc """
  # Takes a height and a width and returns the area of rectangular object.
  # Default values for height and width are both 1.
  # """

  # @spec area(number, number) :: number

  def area({shape, a, b}) do
    area(shape, a, b)
  end

  defp area(shape, a, b) when a >= 0 and b >= 0 do
    case shape do
      :rectangle -> a * b
      :triangle -> a * b / 2.0
      :ellipse -> :math.pi * a * b
      _ -> 0
    end
  end

  defp area(_, _, _) do
    0
  end
end
