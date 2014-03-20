class MonitorController < ApplicationController

  def index
    @srvinfos=Srvinfo.srvinfo_list
  end

  def sys
    hostname=params[:hostname].to_s
    sec=5
    sec_ago=sec.seconds.ago.iso8601
    @vmstats = Vmstat.get_data( hostname, sec_ago )
  end

  def http
    hostname=params[:hostname].to_s
    port=params[:port].to_s

    secs=5
    sec_ago=secs.seconds.ago.iso8601
    now=Time.now.iso8601

    result=Http.get_data(hostname,port,sec_ago,now)

    @count_4XX,@count_23X,@count_5XX = 0,0,0
    result.each do |res|
      @count_23X=res["value"]["total"].to_i if "2XX"==res["_id"]
      @count_4XX=res["value"]["total"].to_i if "4XX"==res["_id"]
      @count_5XX=res["value"]["total"].to_i if "5XX"==res["_id"]
    end


  end

  def edit
  end

end
