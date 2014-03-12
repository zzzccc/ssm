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
    server_name   = Socket.gethostname
    frequency     = 5 # every 5 secs.
    cpu_idle_b    = 0
    cpu_user_b    = 0
    cpu_system_b  = 0

    while true

      vmstat=Vmstat.snapshot

      #puts vmstat.cpus
      cpu_user    = vmstat.cpus[0].user
      cpu_system  = vmstat.cpus[0].system
      cpu_idle    = vmstat.cpus[0].idle
      mem_active  = vmstat.memory.active
      net_in      = vmstat.network_interfaces[0].in_bytes
      net_out     = vmstat.network_interfaces[0].out_bytes

      cpu_idle_b,cpu_user_b,cpu_system_b=cpu_idle,cpu_user,cpu_system if cpu_idle_b==0

      ci  = ((cpu_idle - cpu_idle_b)/frequency).to_i
      cu  = ((cpu_user - cpu_user_b)/frequency).to_i
      cs  = ((cpu_system - cpu_system_b)/frequency).to_i

      cpu_idle_b    = cpu_idle
      cpu_user_b    = cpu_user
      cpu_system_b  = cpu_system

      time    = Time.now.to_i
      record  = { server_name: server_name ,  cpu_idle: ci , cpu_user: cu , cpu_system: cs , mem_active: mem_active , net_in: net_in , net_out: net_out , time: time}
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