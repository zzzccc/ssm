
function get_info(hostname, name, url_type, context, port) {

  var values = [];
  var i = 0;
  var last;

  var sys_url="http://"+location.host+"/sys/"+encodeURIComponent(hostname);
  var http_url="http://"+location.host+"/http/"+encodeURIComponent(hostname)+"/"+port;
  var url="";

  if(url_type=="sys") url = sys_url;
  if(url_type=="http") url = http_url;

  return context.metric(function(start, stop, step, callback) {
    
    $.getJSON(url , 
      function(result){ 

        start = +start, stop = +stop;
        if (isNaN(last)) last = start;
        
        while (last < stop) {
          last += step;

          if(name.match(/.*load_average_one$/)) values.push(result[result.length-1].load_average_one);
          if(name.match(/.*load_average_five$/)) values.push(result[result.length-1].load_average_five);
          if(name.match(/.*load_average_fifteen$/)) values.push(result[result.length-1].load_average_fifteen);
          if(name.match(/.*23x$/)) values.push(result.count_23x);
          if(name.match(/.*5xx$/)) values.push(result.count_5xx);
          if(name.match(/.*4xx$/)) values.push(result.count_4xx);
        }

        callback(null, values = values.slice((start - stop) / step));

    });
  }, name);
}



function chart(hostname, ports, chart_div, context){

  var load_average_one      = get_info(hostname,hostname+" load_average_one","sys",context);
  var load_average_five      = get_info(hostname,hostname+" load_average_five","sys",context);
  var load_average_fifteen      = get_info(hostname,hostname+" load_average_fifteen","sys",context);
  

  var http_array=[];
  for(var i=0;i<ports.length;i++){
    http_array.push(get_info(hostname,hostname+"-"+ports[i]+" 23x","http",context,ports[i]));
    http_array.push(get_info(hostname,hostname+"-"+ports[i]+" 5xx","http",context,ports[i]));
    http_array.push(get_info(hostname,hostname+"-"+ports[i]+" 4xx","http",context,ports[i]));
  }

  d3.select(chart_div).call(function(div) {

    if(chart_div=="#chart0"){
    div.append("div")
        .attr("class", "axis")
        .call(context.axis().orient("top"));
      }

    div.selectAll(".horizon")
        .data([load_average_one,load_average_five,load_average_fifteen])// add,subtract,multuiply,divide
      .enter().append("div")
        .attr("class", "horizon")
        .call(context.horizon().extent([0, 3]))
        .on("click", function(d,i){ alert(d+","+i)});

    div.selectAll(".horizon1")
        .data(http_array)// add,subtract,multuiply,divide
      .enter().append("div")
        .attr("class", "horizon")
        .call(context.horizon().extent([0, 500]));

    div.append("div")
        .attr("class", "rule")
        .call(context.rule());
  });

}


