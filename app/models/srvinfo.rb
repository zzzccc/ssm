class Srvinfo
  include Mongoid::Document
  field :host, type: String
  field :port, type: String

  def self.srvinfo_list
    Srvinfo.all.order("host asc").group_by{ |srv| srv.host}
  end
end
