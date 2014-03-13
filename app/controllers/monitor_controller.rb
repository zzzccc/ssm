class MonitorController < ApplicationController

  def index
    @vmstats=Vmstat.all
    @https=Http.all
  end

  def sys
    sec_5_ago=5.seconds.ago.iso8601
    @vmstats = Vmstat.where( :time => { :$gte => sec_5_ago } )
  end

  def http
    sec_5_ago=10.seconds.ago.iso8601
    now=Time.now.iso8601
    @count_4XX = Http.where( :code => /^4/, :time => { :$gte => sec_5_ago , :$lte => now } ).count
    @count_23X = Http.where( :code => /^2|^3/, :time => { :$gte => sec_5_ago , :$lte => now } ).count
    @count_5XX = Http.where( :code => /^5/, :time => { :$gte => sec_5_ago , :$lte => now } ).count
  end

end
