class Srvinfo
  include Mongoid::Document
  field :host, type: String
  field :port, type: String
end
