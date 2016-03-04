defmodule City do
  defstruct latitude: nil, longitude: nil, name: "", population: 0

  defimpl Valid, for: City do
    def valid?(city) do
      city.population >= 0 &&
      city.latitude >= -90 && city.latitude <= 90 &&
      city.longitude >= -180 && city.longitude <= 180
    end
  end

  defimpl Inspect, for: City do
    def inspect(city, _options) do
      lat = city.latitude
      long = city.longitude
      pretty_lat = if (lat >= 0), do: "#{lat}°N", else: "#{-lat}°S"
      pretty_long = if (long >= 0), do: "#{long}°E", else: "#{-long}°W"
      "#{city.name} (#{city.population}) #{pretty_lat} #{pretty_long}"
    end
  end
end
