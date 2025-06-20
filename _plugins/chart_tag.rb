# 交互式图表插件 - 支持柱状图、饼图、折线图等

module Jekyll
  class ChartTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @options = {}
      markup.scan(/(\w+):\s*(.+?)\s*(?=\w+:|$)/) do |key, value|
        @options[key] = value.strip
      end
      @type = @options["type"] || "bar"
      @title = @options["title"] || ""
      @id = "chart-" + rand(10000..99999).to_s
    end

    def render(context)
      data = JSON.parse(super.strip)
      
      # 确保数据包含所需字段
      unless data.key?("labels") && data.key?("datasets")
        return "错误：数据格式不正确。需要 'labels' 和 'datasets' 字段。"
      end
      
      # 创建图表容器和 JavaScript
      output = <<~HTML
        <div class="chart-container">
          <canvas id="#{@id}" width="400" height="200"></canvas>
        </div>
        
        <script>
        document.addEventListener('DOMContentLoaded', function() {
          const ctx = document.getElementById('#{@id}').getContext('2d');
          const chart = new Chart(ctx, {
            type: '#{@type}',
            data: #{data.to_json},
            options: {
              responsive: true,
              plugins: {
                title: {
                  display: #{!@title.empty?},
                  text: '#{@title}'
                }
              }
            }
          });
        });
        </script>
      HTML
      
      # 在页面头部添加 Chart.js 依赖
      context.registers[:page]["head_scripts"] ||= []
      unless context.registers[:page]["head_scripts"].include?('<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>')
        context.registers[:page]["head_scripts"] << '<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>'
      end
      
      output
    end
  end
end

Liquid::Template.register_tag('chart', Jekyll::ChartTag)