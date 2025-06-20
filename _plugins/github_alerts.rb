# GitHub 风格警告块插件 - 使用 <br> 标签保留换行

module Jekyll
  class GitHubAlertsConverter < Converter
    safe true
    priority :high

    def matches(ext)
      ext =~ /^\.md$/i
    end

    def convert(content)
      # 处理前将内容按行分割
      lines = content.split("\n")
      result = []
      in_alert = false
      alert_type = nil
      alert_title = nil
      alert_content = []
      
      lines.each_with_index do |line, i|
        # 检查是否是新的警告块开始
        if !in_alert && line =~ /^>\s*?\[!(note|tip|important|warning|caution)\](?:\s+(.+?))?$/i
          in_alert = true
          alert_type = $1.downcase
          alert_title = $2 ? $2.strip : nil
          alert_content = []
        # 如果在警告块内，检查是否应该继续
        elsif in_alert
          # 警告块继续的条件：行以 > 开头
          if line =~ /^>\s?(.*)$/
            alert_content << $1
          # 警告块结束的条件：遇到空行或非以 > 开头的行
          else
            # 处理完整的警告块
            prompt_class = case alert_type
              when 'note' then 'prompt-info'
              when 'tip' then 'prompt-tip'
              when 'important' then 'prompt-info'
              when 'warning' then 'prompt-warning'
              when 'caution' then 'prompt-danger'
              else 'prompt-info'
            end
            
            title_html = alert_title ? "<p class=\"prompt-title\">#{alert_title}</p>" : ""
            
            # 使用 <br> 标签连接各行，保留换行
            processed_lines = []
            alert_content.each do |content_line|
              if content_line.strip.empty?
                processed_lines << "<br>"  # 空行转为单个换行
              else
                processed_lines << content_line
              end
            end
            content_html = processed_lines.join("<br>")
            
            result << "<div class=\"prompt #{prompt_class}\">#{title_html}<p>#{content_html}</p></div>"
            
            # 重置警告块状态
            in_alert = false
            
            # 不要忘记处理当前行
            result << line
          end
        # 不在警告块内的普通行
        else
          result << line
        end
      end
      
      # 处理文档末尾可能存在的警告块
      if in_alert
        prompt_class = case alert_type
          when 'note' then 'prompt-info'
          when 'tip' then 'prompt-tip'
          when 'important' then 'prompt-info'
          when 'warning' then 'prompt-warning'
          when 'caution' then 'prompt-danger'
          else 'prompt-info'
        end
        
        title_html = alert_title ? "<p class=\"prompt-title\">#{alert_title}</p>" : ""
        
        # 使用 <br> 标签连接各行，保留换行
        processed_lines = []
        alert_content.each do |content_line|
          if content_line.strip.empty?
            processed_lines << "<br>"  # 空行转为单个换行
          else
            processed_lines << content_line
          end
        end
        content_html = processed_lines.join("<br>")
        
        result << "<div class=\"prompt #{prompt_class}\">#{title_html}<p>#{content_html}</p></div>"
      end
      
      # 重新组合内容
      result.join("\n")
    end

    def output_ext(ext)
      ext
    end
  end
end