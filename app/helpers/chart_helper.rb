module ChartHelper
  include Hasher
  # For more information about OpenFlashChart2Plugin check out the Github repository
  # http://github.com/korin/open_flash_chart_2_plugin
  
  def flash_chart(data=nil, opts={}, id=Time.now.usec)
    return unless data
    
    width  = opts[:width] ? opts[:width] : 680
    height = opts[:height] ? opts[:height] : 400
    
    div_name = "chart#{id}"
    
    <<-CHART
      <div id="#{div_name}" class="notices flash_content">It seems like you don't have Adobe Flash Player installed. Please install it and reload this page.</div>
      
      <script type="text/javascript">
        function #{div_name}Data(){ return '#{data}'; };
        
        swfobject.embedSWF('/flash/chart.swf',
                           '#{div_name}',
                           '#{width}',
                           '#{height}',
                           '9.0.0',
                           '/flash/express_install.swf',
                            {'get-data':'#{div_name}Data'},
                            { wmode:'opaque' },
                            {});
      </script>
    CHART
  end
  
  def flash_chart_from_url data_url, opts={}
    width  = opts[:width] ? opts[:width] : 680
    height = opts[:height] ? opts[:height] : 400
    base          = ""
    flash_base    = "/flash/"
    
    open_flash_chart_2(width, height, "", base, generate_hash(data_url), flash_base)
  end
  
end
