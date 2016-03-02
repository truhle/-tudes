defmodule AskArea do
  def area do
    shape = get_shape
    if is_binary(shape) do
      shape
    else
      {d1, d2} = shape_to_prompts(shape) |> get_dimensions
      calculate(shape, d1, d2)
    end
  end

  defp get_shape do
    answer = IO.gets("R)ectangle, T)riangle, or E)llipse: ")
    shape = String.first(answer) |> String.upcase |> char_to_shape
    if shape == :unknown do
      "Unknown shape #{String.strip(answer)}"
    else
      shape
    end

  end

  defp char_to_shape(char) do
    case char do
      "R" -> :rectangle
      "T" -> :triangle
      "E" -> :ellipse
       _  -> :unknown
    end
  end

  defp shape_to_prompts(shape) do
    case shape do
      :rectangle -> {"width", "height"}
      :triangle -> {"base", "height"}
      :ellipse -> {"major radius", "minor radius"}
    end
  end

  defp get_dimensions(prompts) do
    {p1, p2} = prompts
    {get_number(p1), get_number(p2)}
  end

  defp get_number(prompt) do
    answer = IO.gets("Enter #{prompt} > ")
    String.strip(answer) |> String.to_integer
  end

  defp calculate(shape, d1, d2) when d1 >= 0 and d2 >= 0 do
    Geom.area(shape, d1, d2)
  end

  defp calculate(_shape, _d1, _d2) do
    "Both numbers must be greater than or equal to zero"
  end

end
