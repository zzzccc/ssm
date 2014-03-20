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

  def self.get_data(hostname,port,from,to)
    map = %Q!
      function() {
        var http2xx = new RegExp(/^2|^3/);
        var http4xx = new RegExp(/^4/);
        var http5xx = new RegExp(/^5/);
        if(http2xx.test(this.code)) emit("2XX", {count:1});
        if(http4xx.test(this.code)) emit("4XX", {count:1});
        if(http5xx.test(this.code)) emit("5XX", {count:1});
      }
    !


    reduce = %Q!
      function(key, values) {    
        var result = { total:0};
        result.total = values.length;
        return result;
      }
    !

    Http.where( :time => { :$gte => from , :$lte => to } ,port: "#{port}", server: "#{hostname}" ).map_reduce(map,reduce).out(inline:true)
  end
end
