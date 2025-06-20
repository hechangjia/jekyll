# 选项卡插件

module Jekyll
  class TabsBlock < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @id = "tabs-" + rand(10000..99999).to_s
    end

    def render(context)
      content = super.strip
      
      # 解析选项卡内容
      tabs_content = {}
      current_tab = nil
      tab_content = ""
      
      content.split("\n").each do |line|
        if line =~ /^### (.*)/
          # 如果已有选项卡，保存之前的内容
          if current_tab
            tabs_content[current_tab] = tab_content.strip
          end
          
          # 开始新选项卡
          current_tab = $1.strip
          tab_content = ""
        else
          # 添加到当前选项卡内容
          tab_content += line + "\n"
        end
      end
      
      # 保存最后一个选项卡
      if current_tab
        tabs_content[current_tab] = tab_content.strip
      end
      
      # 生成 HTML
      output = <<~HTML
        <div class="tabs-container" id="#{@id}">
          <div class="tabs-header">
      HTML
      
      # 添加选项卡标题
      tabs_content.keys.each_with_index do |title, index|
        active_class = index == 0 ? "active" : ""
        output += "<div class=\"tab-title #{active_class}\" data-tab=\"tab-#{index}\">#{title}</div>\n"
      end
      
      output += <<~HTML
          </div>
          <div class="tabs-content">
      HTML
      
      # 添加选项卡内容
      tabs_content.values.each_with_index do |content, index|
        active_class = index == 0 ? "active" : ""
        output += "<div class=\"tab-content #{active_class}\" id=\"tab-#{index}\">\n"
        
        # 使用 Markdown 渲染内容
        output += Jekyll::Converters::Markdown.new(context.registers[:site].config).convert(content)
        
        output += "</div>\n"
      end
      
      output += <<~HTML
          </div>
        </div>
        
        <style>
        .tabs-container {
          margin: 20px 0;
        }
        .tabs-header {
          display: flex;
          border-bottom: 1px solid #ddd;
        }
        .tab-title {
          padding: 10px 15px;
          cursor: pointer;
          background-color: #f8f8f8;
          border: 1px solid transparent;
          border-bottom: none;
          margin-right: 5px;
          border-radius: 3px 3px 0 0;
        }
        .tab-title.active {
          background-color: #fff;
          border-color: #ddd;
          border-bottom-color: #fff;
          margin-bottom: -1px;
        }
        .tabs-content {
          border: 1px solid #ddd;
          border-top: none;
          padding: 15px;
        }
        .tab-content {
          display: none;
        }
        .tab-content.active {
          display: block;
        }
        </style>
        
        <script>
        document.addEventListener('DOMContentLoaded', function() {
          const tabs = document.querySelectorAll('##{@id} .tab-title');
          tabs.forEach(tab => {
            tab.addEventListener('click', function() {
              // 移除所有活动状态
              document.querySelectorAll('##{@id} .tab-title').forEach(t => t.classList.remove('active'));
              document.querySelectorAll('##{@id} .tab-content').forEach(c => c.classList.remove('active'));
              
              // 设置当前选项卡为活动状态
              this.classList.add('active');
              const tabId = this.getAttribute('data-tab');
              document.getElementById(tabId).classList.add('active');
            });
          });
        });
        </script>
      HTML
      
      output
    end
  end
end

Liquid::Template.register_tag('tabs', Jekyll::TabsBlock)