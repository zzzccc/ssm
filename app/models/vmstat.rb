class Vmstat
  include Mongoid::Document

  field :server_name, type: String

  field :mem_active, type: Integer
  field :mem_wired, type: Integer
  field :mem_inactive, type: Integer
  field :mem_free, type: Integer
  field :mem_pageins, type: Integer
  field :mem_pageouts, type: Integer
  field :load_average_one, type: Float
  field :load_average_five, type: Float
  field :load_average_fifteen, type: Float
  field :net_names, type: Array
  field :net_ins, type: Array
  field :net_in_errs, type: Array
  field :net_outs, type: Array
  field :net_out_errs, type: Array

  field :time, type: DateTime

  def self.get_data(hostname,time)
    result=Vmstat.new({load_average_one: 0, load_average_five:0, load_average_fifteen:0})
    vmstats = Vmstat.where( time: { :$gte => time } , server_name: "#{hostname}" )
    if vmstats.length > 0
      result.load_average_one     = vmstats.last.load_average_one
      result.load_average_five    = vmstats.last.load_average_five
      result.load_average_fifteen = vmstats.last.load_average_fifteen
    end
   
    [result]
  end
  
end
