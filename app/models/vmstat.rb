class Vmstat
  include Mongoid::Document

  field :server_name, type: String
  field :mem_active, type: Integer
  field :cpu_idle, type: Integer
  field :cpu_user, type: Integer
  field :cpu_system, type: Integer
  field :net_in, type: Integer
  field :net_out, type: Integer
  field :time, type: DateTime

  def self.get_data(hostname,time)
    result=Vmstat.new({ :mem_active => 0, :cpu_idle => 0 , :cpu_user => 0 , :cpu_system => 0 , :net_in => 0 , :net_out => 0})
    vmstats = Vmstat.where( time: { :$gte => time } , server_name: "#{hostname}" )
    vmstats.each do |vmstat|
      #puts "--------#{vmstat}"
      result.mem_active  += vmstat.mem_active
      result.cpu_idle    += vmstat.cpu_idle
      result.cpu_user    += vmstat.cpu_user
      result.cpu_system  += vmstat.cpu_system
      result.net_in      += vmstat.net_in
      result.net_out     += vmstat.net_out
      result.server_name = vmstat.server_name
      result.time        = vmstat.time
    end
    length = (vmstats.length==0 ? 1: vmstats.length)
    result.mem_active  = (result.mem_active/length).to_i
    result.cpu_idle    = (result.cpu_idle/length).to_i
    result.cpu_user    = (result.cpu_user/length).to_i
    result.cpu_system  = (result.cpu_system/length).to_i
    result.net_in      = (result.net_in/length).to_i
    result.net_out     = (result.net_out/length).to_i
    #puts ">>>>>>>>>#{result.cpu_system}"
    [result]
  end
  
end
