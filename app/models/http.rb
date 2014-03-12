class Http
  include Mongoid::Document

  field :server, type: String
  field :port, type: Integer
  field :remote, type: String
  field :host, type: String
  field :user, type: String
  field :size, type: Integer
  field :code, type: Integer
  field :method, type: String
  field :agent, type: String
  field :time, type: DateTime
end
