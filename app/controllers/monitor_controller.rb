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

    map = %Q!
      function() {
        var http2xx = new RegExp(/^2|^3/);
        var http4xx = new RegExp(/^4/);
        var http5xx = new RegExp(/^5/);
        if(http2xx.test(this.code)) emit("2XX", {count:1});
        if(http4xx.test(this.code)) emit("4XX", {count:1});
        if(http5xx.test(this.code)) emit("5XX", {count:1});
      }
    !


    reduce = %Q!
      function(key, values) {    
        var result = { total:0};
        result.total = values.length;
        return result;
      }
    !

    result=Http.where( :time => { :$gte => sec_ago , :$lte => now } ,port: "#{port}", server: "#{hostname}" ).map_reduce(map,reduce).out(inline:true)

    @count_4XX,@count_23X,@count_5XX = 0,0,0
    result.each do |res|
      @count_23X=res["value"]["total"].to_i if "2XX"==res["_id"]
      @count_4XX=res["value"]["total"].to_i if "4XX"==res["_id"]
      @count_5XX=res["value"]["total"].to_i if "5XX"==res["_id"]
    end


    #@count_4XX = Http.where( :code => /^4/, :time => { :$gte => sec_ago , :$lte => now } ,port: "#{port}", server: "#{hostname}").count
    #@count_23X = Http.where( :code => /^2|^3/, :time => { :$gte => sec_ago , :$lte => now } ,port: "#{port}", server: "#{hostname}").count
    #@count_5XX = Http.where( :code => /^5/, :time => { :$gte => sec_ago , :$lte => now } ,port: "#{port}", server: "#{hostname}").count
  end

  def edit
  end

end
