defmodule Dates do

  def date_parts(date_string) do
    String.split(date_string, "-")
    |> Enum.map(fn(str) -> String.to_integer(str) end)
  end

  def julian(date_string) do
    [y,m,d] = date_parts(date_string)
    feb_days = if (is_leap_year(y)), do: 29, else: 28
    days_list = [31, feb_days, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    d + month_total(m, days_list, 0)
  end

  def month_total(1, _days_list, total) do
    total
  end

  def month_total(month, days_list, total) do
    [h|t] = days_list
    month_total(month - 1, t, total + h)
  end

  defp is_leap_year(year) do
    (rem(year,4) == 0 and rem(year,100) != 0) or (rem(year,400) == 0)
  end

end
