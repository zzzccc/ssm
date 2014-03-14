class Srvinfo
  include Mongoid::Document
  field :host, type: String
  field :post, type: String
end
