function get_info(name , url_type ,context) {

  var value = 0;
  var values = [];
  var i = 0;
  var last;

  var sys_url="http://localhost:3000/sys.json";
  var http_url="http://localhost:3000/http.json";
  var url="";

  if(url_type=="sys") url = sys_url;
  if(url_type=="http") url = http_url;

  console.log("url="+url);

  return context.metric(function(start, stop, step, callback) {
    
    $.getJSON(url , 
      function(result){ 

        start = +start, stop = +stop;
        if (isNaN(last)) last = start;
        while (last < stop) {
          last += step;

          if (url_type=="sys"){
              if(name=="user") values.push(result[result.length-1].cpu_user);
              if(name=="sys") values.push(result[result.length-1].cpu_system);
          }

          if(url_type=="http"){
            if(name=="23x") values.push(result.count_23x);
            if(name=="5xx") values.push(result.count_5xx);
          }
        }
        callback(null, values = values.slice((start - stop) / step));

    });
  }, name);
}


function chart(){

  var width = $("#chart").width();
  var context = cubism.context()
    .serverDelay(0)
    .clientDelay(0)
    .step(1e3)
    .size(width);

  var user      = get_info("user","sys",context);
  var sys       = get_info("sys", "sys",context);
  var http_23x   = get_info("23x","http",context);
  var http_5xx   = get_info("5xx","http",context);

  d3.select("#chart").call(function(div) {

    div.append("div")
        .attr("class", "axis")
        .call(context.axis().orient("top"));

    div.selectAll(".horizon")
        .data([user.add(sys), user,sys])// add,subtract,multuiply,divide
      .enter().append("div")
        .attr("class", "horizon")
        .call(context.horizon().extent([0, 100]));

    div.selectAll(".horizon1")
        .data([http_23x, http_5xx])
      .enter().append("div")
        .attr("class", "horizon")
        .call(context.horizon().extent([0, 500]));

    div.append("div")
        .attr("class", "rule")
        .call(context.rule());
  });

  // On mousemove, reposition the chart values to match the rule.
  context.on("focus", function(i) {
    d3.selectAll(".value").style("right", i == null ? null : context.size() - i + "px");
  });

}


