class MonitorController < ApplicationController

  def index
    @srvinfos=Srvinfo.srvinfo_list
  end

  def sys
    hostname=params[:hostname].to_s
    sec=5
    sec_ago=sec.seconds.ago.iso8601
    @vmstats = Vmstat.get_data( hostname, sec_ago,sec )
  end

  def http
    hostname=params[:hostname].to_s
    port=params[:port].to_s

    secs=5
    sec_ago=secs.seconds.ago.iso8601
    now=Time.now.iso8601
    @count_4XX = Http.where( :code => /^4/, :time => { :$gte => sec_ago , :$lte => now } ).in( port: "#{port}", server: ["#{hostname}"] ).count
    @count_23X = Http.where( :code => /^2|^3/, :time => { :$gte => sec_ago , :$lte => now } ).in( port: "#{port}", server: ["#{hostname}"] ).count
    @count_5XX = Http.where( :code => /^5/, :time => { :$gte => sec_ago , :$lte => now } ).in( port: "#{port}", server: ["#{hostname}"] ).count
  end

  def edit
  end

end
