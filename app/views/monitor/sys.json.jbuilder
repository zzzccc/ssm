json.array!(@vmstats) do |vmstat|
  json.extract! vmstat , :server_name , :mem_active, :net_in, :net_out, :time , :cpu_idle , :cpu_system , :cpu_user
end
