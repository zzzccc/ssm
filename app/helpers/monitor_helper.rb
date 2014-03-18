module MonitorHelper

  def draw(srvinfos)
    arr=[]
    srvinfos.each_with_index do |srvinfo,index|
      arr << "chart('#{srvinfo.host}',['#chart#{index*2}','#chart#{index*2+1}'],context1);"
    end
    arr.join(" ")
  end
end
