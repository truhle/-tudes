defmodule Geography do
  def make_geo_list(csv_file) do
    parse_file(csv_file) |> list_to_geo_list
  end

  def parse_file(csv_file) do
    {result, device} = File.open(csv_file, [:read, :utf8])
    case result do
      :ok -> read_lines(device, [])
      _ -> raise "File could not be opened: #{device}"
    end
  end

  def read_lines(device, accum) do
    line = IO.read(device, :line)
    case line do
      :eof ->
        File.close(device)
        Enum.reverse(accum)
      _ ->
        list = String.rstrip(line) |> String.split(",")
        read_lines(device, [list | accum])
    end
  end

  def list_to_geo_list(list) do
    list_to_geo_list(list, [])
  end

  def list_to_geo_list([], geo_list) do
    geo_list
  end

  def list_to_geo_list([h|t], geo_list) do
    case h do
      [country, lang] ->
        list_to_geo_list(t, [%Country{name: country,
                                language: lang} | geo_list])
      [city, population, lat, long] ->
        [geoh | geot] = geo_list
        {_, new_geoh} = Map.get_and_update(geoh, :cities,
          fn current ->
            {current, [%City{name: city,
                             population: String.to_integer(population),
                             latitude: String.to_float(lat),
                             longitude: String.to_float(long)}
                             | current]}
        end)
        list_to_geo_list(t, [new_geoh | geot])
    end
  end

  def total_population(geo_list, lang) do
    Enum.reduce(geo_list, 0, fn (country, sum) ->
      case country.language do
        ^lang ->
          sum + Enum.reduce(country.cities, 0, fn (city, pop) ->
            pop + city.population
          end)
        _ ->
          sum
      end
    end)
  end
end
