require 'mongo'
require 'active_support/all'
include Mongo

# 통계 데이타 생성 
# 지금부터 지난 x분 의데이타를 읽어서 , vmstat, httpcode 정보의 x분 평균값을 저장한다.
# ssm에서 지정한 날짜의 하루데이타를 조회할때 이용된다.
# 컬렉션 : stats
# 컬럼 : sys , user , net , mem , disk , http2xx , http4xx , http5xx
client=MongoClient.new("localhost",MongoClient::DEFAULT_PORT)

db=client['ssm_development']
https=db['https']
vmstats=db['vmstats']
servers=db['srvinfos']

from=60000.minutes.ago
now=Time.now

puts "#{from},#{now}"

srv_info={}

servers.find().each { |srv| (srv_info[srv['host']] ||= []) << srv['port'] }

srv_info.each{ |key,value| puts "#{key}:#{value}" }

#db.collections.each{|col| p col }

srv_info.each do |host,ports|
  ports.each do |port|
    http2xx=https.find({code: /^2|^3/ , time: { "$gte" => from , "$lte" => now } , port: "#{port}", server: "#{host}"}).count  
    http4xx=https.find({code: /^4/ , time: { "$gte" => from , "$lte" => now } , port: "#{port}", server: "#{host}"}).count  
    http5xx=https.find({code: /^5/ , time: { "$gte" => from , "$lte" => now } , port: "#{port}", server: "#{host}"}).count  
    puts "#{host}:#{port} => 2XX:#{http2xx} , 4XX:#{http4xx}, 5XX:#{http5xx}"
  end
end


#puts https.find({time: { "$gte" => from , "$lte" => now } , port: "80", server: "xubuntu"}).count
#puts https.find({"time" => { "$gte" => from , "$lte" => now } , "port" => "80", "server" => "xubuntu"}).map_reduce(map,reduce, { out: { inline: true , raw: true} })
#puts vmstats.find().count