require 'vmstat'
require 'socket'
class VmstatInput < Fluent::Input
  # First, register the plugin. NAME is the name of this plugin
  # and identifies the plugin in the configuration file.
  Fluent::Plugin.register_input('vmstat', self)

  # This method is called before starting.
  # 'conf' is a Hash that includes configuration parameters.
  # If the configuration is invalid, raise Fluent::ConfigError.
  def configure(conf)
    super
    @tag = conf["tag"]
  end

  # This method is called when starting.
  # Open sockets or files and create a thread here.
  def start
    super
    server_name   = Socket.gethostname.downcase
    frequency     = 1 # every 1 secs.
    
    while true

      vmstat=Vmstat.snapshot

      mem_active    = vmstat.memory.active
      mem_wired     = vmstat.memory.wired
      mem_inactive  = vmstat.memory.inactive
      mem_free      = vmstat.memory.free
      mem_pageins   = vmstat.memory.pageins
      mem_pageouts  = vmstat.memory.pageouts

      # NETWORK
      net_names,net_ins,net_in_errs,net_outs,net_out_errs=[],[],[],[],[]
      vmstat.network_interfaces.each do |net|
        #puts "#{net.name},#{net.in_bytes},#{net.in_errors},#{net.out_bytes},#{net.out_errors}"
        net_names     << net.name
        net_ins       << net.in_bytes
        net_in_errs   << net.in_errors
        net_outs      << net.out_bytes
        net_out_errs  << net.out_errors
      end

      time    = Time.now.to_i

      record  = { 
                  server_name: server_name ,  
                  mem_active: mem_active , 
                  mem_wired: mem_wired , 
                  mem_inactive: mem_inactive , 
                  mem_free: mem_free , 
                  mem_pageins: mem_pageins , 
                  mem_pageouts: mem_pageouts , 
                  load_average_one: vmstat.load_average.one_minute,
                  load_average_five: vmstat.load_average.five_minutes,
                  load_average_fifteen: vmstat.load_average.fifteen_minutes,
                  net_names: net_names , 
                  net_ins: net_ins , 
                  net_in_errs: net_in_errs , 
                  net_outs: net_outs , 
                  net_out_errs: net_out_errs,
                  time: time
                }

      Fluent::Engine.emit(@tag, time, record)
      sleep(frequency)
    end

  end

  # This method is called when shutting down.
  # Shutdown the thread and close sockets or files here.
  def shutdown
    puts "shutdown"
  end
end