module MonitorHelper

  def draw(srvinfos,context)
    index,arr=0,[]
    srvinfos.each do |key,srvinfo|
      port_str=[]
      srvinfo.each_with_index do |si,index|
        port_str << si.port
        #puts ">>>>> #{key} chart('#{si.host}', ['#chart#{index*2}','#chart#{index*2+1}'] , #{context});"
      end
      arr << "chart('#{key}',[#{port_str.join(',')}],'#chart#{index}',#{context});"
      index +=1

      puts arr
    end
    arr.join(" ")
    #{}"chart('xubuntu', [80,8080] , '#chart0',#{context}); chart('172.20.nate.com', [99,999],'#chart1',#{context});"
  end

end
