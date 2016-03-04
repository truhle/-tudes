defmodule College do
  def make_room_list(file) do
    parse_file(file) |> courses_to_room_map()
  end

  def parse_file(file) do
    {result, device} = File.open(file)
    if (result == :ok),
      do: read_lines(device, []),
    else: "Error opening file #{device}"
  end

  def read_lines(device, accum) do
    data = IO.read(device, :line)
    case data do
      :eof ->
        File.close(device)
        accum
      _ ->
        list = String.rstrip(data) |> String.split(",")
        read_lines(device, [list | accum])
    end
  end

  def courses_to_room_map(course_list) do
    courses_to_room_map(course_list, %{})
  end

  def courses_to_room_map([], map) do
    map
  end

  def courses_to_room_map([h|t], map) do
    [_, course, room_number] = h
    {_, new_map} = Map.get_and_update(map, room_number, fn(current_value) ->
      case current_value do
        nil -> {current_value, [course]}
        _ -> {current_value, [course | current_value]}
      end
    end)
    courses_to_room_map(t, new_map)
  end
end
