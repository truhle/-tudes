defmodule Geom do
  @moduledoc """
  Functions calculating gemoetric values.
  """

  @doc """
  Takes a height and a width and returns the area of rectangular object.
  Default values for height and width are both 1.
  """

  @spec area(number, number) :: number
  
  def area(height \\ 1, width \\ 1) do
    height * width
  end
end
