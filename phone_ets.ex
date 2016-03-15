defmodule PhoneETS do
  require Call

  def setup(csv_file) do
    case :ets.info(:calls) do
      :undefined -> false
      _ -> :ets.delete(:calls)
    end

    :ets.new(:calls, [:bag, :named_table, {:keypos, Call.call(:number) + 1}])
    info = file_to_list(csv_file)
    insert_into_table(info)
  end

  def file_to_list(csv) do
    {result, device} = File.open(csv)
    case result do
      :ok -> parse_lines(device, [])
      _ -> "Error opening file #{device}"
    end
  end

  def parse_lines(device, accum) do
    data = IO.read(device, :line)
    case data do
      :eof ->
        File.close(device)
        accum
      _ ->
        line = String.rstrip(data) |> String.split(",")
        tuple_line = convert_datetimes(line) |> List.to_tuple()
        parse_lines(device, [tuple_line | accum])
    end
  end

  def convert_datetimes(tuple) do
    Enum.map(tuple, fn(entry) ->
      length = String.length(entry)
      cond do
        length > 10 -> entry
        length > 8 -> parse_entry(entry, "-")
        true -> parse_entry(entry, ":")
      end
    end)
  end

  def parse_entry(str, separator) do
    String.split(str, separator) |> Enum.map(fn(num) ->
       String.to_integer(num)
     end) |> List.to_tuple()
  end

  def insert_into_table([]) do
    :undefined
  end

  def insert_into_table([{number, start_date, start_time, end_date, end_time} | tail]) do
    :ets.insert(:calls, Call.call(number: number, start_date: start_date, start_time: start_time, end_date: end_date, end_time: end_time))
    insert_into_table(tail)
  end

  def summary do
    first_number = :ets.first(:calls)
    summary(first_number, [])
  end

  def summary(number, list) do
    case number do
      :"$end_of_table" -> list
      _ ->
        new_list = summary(number) ++ list
        next_number = :ets.next(:calls, number)
        summary(next_number, new_list)
    end
  end

  def summary(number) do
    calls = :ets.lookup(:calls, number)
    minutes = List.foldl(calls, 0, fn(call, acc) ->
      c_start = :calendar.datetime_to_gregorian_seconds(
        {Call.call(call, :end_date), Call.call(call, :end_time)})
      c_end = :calendar.datetime_to_gregorian_seconds(
        {Call.call(call, :start_date), Call.call(call, :start_time)})
      seconds = c_start - c_end
      div(seconds + 59, 60) + acc
    end)
    [{number, minutes}]
  end

end
