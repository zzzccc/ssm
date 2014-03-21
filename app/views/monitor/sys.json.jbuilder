json.array!(@vmstats) do |vmstat|
  json.extract! vmstat , :server_name , :load_average_one, :load_average_five, :load_average_fifteen
end
