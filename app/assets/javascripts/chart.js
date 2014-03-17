
function get_info(hostname, name , url_type,context) {

  var values = [];
  var i = 0;
  var last;

  var sys_url="http://localhost:3000/sys/"+encodeURIComponent(hostname);
  var http_url="http://localhost:3000/http/"+encodeURIComponent(hostname);
  var url="";

  if(url_type=="sys") url = sys_url;
  if(url_type=="http") url = http_url;

  var deleim_token=hostname+name;

  return context.metric(function(start, stop, step, callback) {
    
    $.getJSON(url , 
      function(result){ 

        start = +start, stop = +stop;
        if (isNaN(last)) last = start;
        while (last < stop) {
          last += step;

          if (url_type=="sys"){
              if(name.match(/.*user$/)) values.push(result[result.length-1].cpu_user);
              if(name.match(/.*sys$/)) values.push(result[result.length-1].cpu_system);
          }

          if(url_type=="http"){
            if(name.match(/.*23x$/)) values.push(result.count_23x);
            if(name.match(/.*5xx$/)) values.push(result.count_5xx);
          }
        }
        callback(null, values = values.slice((start - stop) / step));

    });
  }, name);
}



function chart(hostname, chart_div,context){

  

  var user      = get_info(hostname,hostname+" user","sys",context);
  var sys       = get_info(hostname,hostname+" sys", "sys",context);
  var http_23x   = get_info(hostname,hostname+" 23x","http",context);
  var http_5xx   = get_info(hostname,hostname+"5xx","http",context);

  d3.select(chart_div[0]).call(function(div) {

    div.append("div")
        .attr("class", "axis")
        .call(context.axis().orient("top"));

    div.selectAll(".horizon")
        .data([user.add(sys), user, sys])// add,subtract,multuiply,divide
      .enter().append("div")
        .attr("class", "horizon")
        .call(context.horizon().extent([0, 100]));

    div.append("div")
        .attr("class", "rule")
        .call(context.rule());
  });


  d3.select(chart_div[1]).call(function(div) {

    div.selectAll(".horizon")
        .data([http_23x , http_5xx])// add,subtract,multuiply,divide
      .enter().append("div")
        .attr("class", "horizon")
        .call(context.horizon().extent([0, 500]));

    div.append("div")
        .attr("class", "rule")
        .call(context.rule());

  });

  

}


