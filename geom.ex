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

  defp area(:rectangle, height, width) when height >= 0 and width >= 0 do
    height * width
  end

  defp area(:triangle, base, height) when base >= 0 and height >= 0  do
    base * height / 2.0
  end

  defp area(:ellipse, major_radius, minor_radius) when major_radius >= 0 and minor_radius >= 0  do
    :math.pi * major_radius * minor_radius
  end

  defp area(_, _, _) do
    0
  end
end
