# 交互式时间线插件

module Jekyll
  class TimelineTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @options = {}
      markup.scan(/(\w+):\s*(.+?)\s*(?=\w+:|$)/) do |key, value|
        @options[key] = value.strip
      end
      @title = @options["title"] || "时间线"
    end

    def render(context)
      events = YAML.safe_load(super)
      timeline_id = "timeline-" + rand(10000..99999).to_s
      
      # 创建时间线 HTML
      output = <<~HTML
        <div class="timeline-container">
          <h3 class="timeline-title">#{@title}</h3>
          <div class="timeline" id="#{timeline_id}">
      HTML
      
      events.each_with_index do |event, index|
        position = index.even? ? "left" : "right"
        output += <<~HTML
          <div class="timeline-item #{position}">
            <div class="timeline-content">
              <div class="timeline-date">#{event["date"]}</div>
              <h4>#{event["title"]}</h4>
              <p>#{event["description"]}</p>
              #{event["image"] ? "<img src=\"#{event["image"]}\" alt=\"#{event["title"]}\">" : ""}
            </div>
          </div>
        HTML
      end
      
      output += <<~HTML
          </div>
        </div>
        
        <style>
        .timeline-container {
          margin: 30px 0;
          position: relative;
        }
        .timeline-title {
          text-align: center;
          margin-bottom: 20px;
        }
        .timeline {
          position: relative;
          padding: 30px 0;
        }
        .timeline:before {
          content: '';
          position: absolute;
          height: 100%;
          width: 3px;
          background: #d4d4d4;
          left: 50%;
          transform: translateX(-50%);
        }
        .timeline-item {
          margin-bottom: 40px;
          position: relative;
          width: 100%;
        }
        .timeline-content {
          background: #f5f5f5;
          border-radius: 8px;
          padding: 15px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          position: relative;
          width: 45%;
        }
        .timeline-content h4 {
          margin-top: 0;
        }
        .timeline-date {
          font-weight: bold;
          margin-bottom: 8px;
          color: #666;
        }
        .timeline-content img {
          max-width: 100%;
          margin-top: 10px;
          border-radius: 4px;
        }
        .timeline-item.left .timeline-content {
          float: left;
        }
        .timeline-item.right .timeline-content {
          float: right;
        }
        .timeline-item.left .timeline-content:before {
          content: '';
          position: absolute;
          right: -12px;
          top: 15px;
          width: 12px;
          height: 12px;
          background: #d4d4d4;
          border-radius: 50%;
        }
        .timeline-item.right .timeline-content:before {
          content: '';
          position: absolute;
          left: -12px;
          top: 15px;
          width: 12px;
          height: 12px;
          background: #d4d4d4;
          border-radius: 50%;
        }
        /* 清除浮动 */
        .timeline-item:after {
          content: '';
          display: block;
          clear: both;
        }
        </style>
      HTML
      
      output
    end
  end
end

Liquid::Template.register_tag('timeline', Jekyll::TimelineTag)