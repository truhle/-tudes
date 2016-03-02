defmodule Dates do

  def date_parts(date_string) do
    String.split(date_string, "-")
    |> Enum.map(fn(str) -> String.to_integer(str) end)
  end

end
