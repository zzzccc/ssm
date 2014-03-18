module MonitorHelper

  def draw(srvinfos)
    arr=[]
    srvinfos.each do |key,srvinfo|
      srvinfo.each_with_index do |si,index|
        puts ">>>>> #{key} chart('#{si.host}', ['#chart#{index*2}','#chart#{index*2+1}'] , context1);"
      end
    end
    arr.join(" ")
    
    "chart('172.20.nate.com', [80,8080] , ['#chart0','#chart1'],context1); chart('172.20.nate.com', [99,999],['#chart2','#chart3'],context1);"

  end
end
