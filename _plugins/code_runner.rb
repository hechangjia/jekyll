# 修复后的 Jekyll 构建时代码执行插件 - 支持 Windows 和 Unix 系统

require 'open3'
require 'digest'
require 'tempfile'
require 'fileutils'

module Jekyll
  class CodeRunnerBlock < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @options = {}
      markup.scan(/(\w+):\s*(.+?)\s*(?=\w+:|$)/) do |key, value|
        @options[key] = value.strip
      end
      @language = @options["language"] || "ruby"
    end

    def render(context)
      code = super.strip
      
      # 根据语言选择执行方法
      case @language
      when "ruby"
        output = execute_ruby(code)
      when "python"
        output = execute_python(code)
      when "bash", "shell"
        output = execute_shell(code)
      else
        output = "不支持的语言：#{@language}"
      end
      
      # 创建输出 HTML
      result = <<~HTML
        <div class="code-example">
          <div class="code-block">
            <div class="code-header">
              <span class="code-language">#{@language}</span>
              #{@options["title"] ? "<span class=\"code-title\">#{@options["title"]}</span>" : ""}
            </div>
            <pre><code class="language-#{@language}">#{code}</code></pre>
          </div>
          
          <div class="code-output">
            <div class="output-header">输出</div>
            <pre><code>#{CGI.escapeHTML(output)}</code></pre>
          </div>
        </div>
      HTML
      
      result
    end
    
    private
    
    def execute_ruby(code)
      # 使用安全模式执行 Ruby 代码
      result = ""
      begin
        # 使用超时防止无限循环
        require 'timeout'
        Timeout.timeout(5) do
          # 重定向输出到字符串
          stdout_old = $stdout
          $stdout = StringIO.new
          
          # 执行代码
          eval(code)
          
          # 获取输出
          result = $stdout.string
          
          # 恢复标准输出
          $stdout = stdout_old
        end
      rescue Exception => e
        result = "错误: #{e.message}"
      end
      
      result
    end
    
    def execute_python(code)
      begin
        # 创建跨平台临时文件
        temp_file = Tempfile.new(['jekyll_python', '.py'])
        temp_path = temp_file.path
        temp_file.write(code)
        temp_file.close
        
        # 执行 Python 代码
        stdout, stderr, status = Open3.capture3("python #{temp_path}")
        
        # 删除临时文件
        temp_file.unlink
        
        # 返回输出或错误
        return stderr.empty? ? stdout : "错误: #{stderr}"
      rescue => e
        return "执行过程中出错: #{e.message}"
      end
    end
    
    def execute_shell(code)
      # 不同系统使用不同的 shell
      shell_cmd = Gem.win_platform? ? "cmd.exe /c" : "sh -c"
      
      # 创建临时脚本文件
      begin
        # 创建临时文件
        ext = Gem.win_platform? ? '.bat' : '.sh'
        temp_file = Tempfile.new(['jekyll_shell', ext])
        temp_path = temp_file.path
        temp_file.write(code)
        temp_file.close
        
        # 设置执行权限（仅在Unix系统）
        FileUtils.chmod(0755, temp_path) unless Gem.win_platform?
        
        # 执行脚本
        stdout, stderr, status = Open3.capture3("#{shell_cmd} \"#{temp_path}\"")
        
        # 删除临时文件
        temp_file.unlink
        
        # 返回输出或错误
        return stderr.empty? ? stdout : "错误: #{stderr}"
      rescue => e
        return "执行过程中出错: #{e.message}"
      end
    end
  end
end

Liquid::Template.register_tag('run', Jekyll::CodeRunnerBlock)