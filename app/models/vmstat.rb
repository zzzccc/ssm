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
end
