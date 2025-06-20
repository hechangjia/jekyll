# 更新版 GitHub 风格警告块插件 - 支持标题

module Jekyll
  class GitHubAlertsConverter < Converter
    safe true
    priority :high

    def matches(ext)
      ext =~ /^\.md$/i
    end

    def convert(content)
      # 匹配 GitHub 警告块语法: >[!TYPE] 可选标题
      alert_pattern = /^>\s*?\[!(note|tip|important|warning|caution)\](?:\s+(.+?))?\s*?$(.*?)(?=^>|\Z)/mi

      content.gsub(alert_pattern) do |match|
        alert_type = $1.downcase
        alert_title = $2 ? $2.strip : nil
        alert_content = $3.strip
        
        # 将内容中的 > 前缀去掉
        alert_content = alert_content.gsub(/^>\s?/, '')
        
        # 将 GitHub 警告类型映射到 Chirpy 的 prompt 类
        prompt_class = case alert_type
          when 'note' then 'prompt-info'
          when 'tip' then 'prompt-tip'
          when 'important' then 'prompt-info'
          when 'warning' then 'prompt-warning'
          when 'caution' then 'prompt-danger'
          else 'prompt-info'
        end
        
        title_html = alert_title ? "<p class=\"prompt-title\">#{alert_title}</p>" : ""
        
        "<div class=\"prompt #{prompt_class}\">#{title_html}<p>#{alert_content}</p></div>\n\n"
      end
    end

    def output_ext(ext)
      ext
    end
  end
end