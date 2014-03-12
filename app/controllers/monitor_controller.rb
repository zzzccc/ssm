class MonitorController < ApplicationController

  def index
    @vmstats=Vmstat.all
    @https=Http.all
  end

end
