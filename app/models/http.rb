class Http
  include Mongoid::Document

  field :server, type: String
  field :port, type: String
  field :remote, type: String
  field :host, type: String
  field :user, type: String
  field :size, type: String
  field :code, type: String
  field :method, type: String
  field :agent, type: String
  field :time, type: DateTime
end
