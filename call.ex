defmodule Call do
  require Record
  Record.defrecord :call, [number: nil, start_date: "1900-01-01",
    start_time: "00:00:00", end_date: "1900-01-01", end_time: "00:00:00"]
end
