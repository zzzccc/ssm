#json.array!(@https) do |vmstat|
#  json.extract! vmstat, :server, :port, :remote, :host , :user , :size , :code , :method , :agent , :time
  #json.url vmstat_url(vmstat, format: :json)
#end

json.count_4xx @count_4XX
json.count_23x @count_23X
json.count_5xx @count_5XX
