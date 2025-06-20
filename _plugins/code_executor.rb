# Jekyll 代码执行插件 - 支持 Python, JavaScript, Ruby 等语言
# 注意：此插件需要客户端 JavaScript 支持

module Jekyll
  class CodeExecutorTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @language = markup.strip
      @supported_languages = ["python", "javascript", "ruby", "c", "cpp"]
      raise "不支持的语言：#{@language}" unless @supported_languages.include?(@language)
    end

    def render(context)
      code = super.strip
      id = "code-" + Digest::MD5.hexdigest(code)[0, 8]
      
      output = <<~HTML
        <div class="code-execution-block">
          <div class="code-container">
            <pre><code class="language-#{@language}">#{code}</code></pre>
          </div>
          <div class="execution-controls">
            <button class="execute-button" data-id="#{id}" data-lang="#{@language}">运行代码</button>
            <div class="code-reset" data-id="#{id}">重置</div>
          </div>
          <div class="execution-results" id="result-#{id}">
            <div class="result-header">输出：</div>
            <pre class="result-output"></pre>
          </div>
        </div>
        
        <script type="text/javascript">
          document.addEventListener('DOMContentLoaded', function() {
            // 初始化执行按钮
            const executeButton_#{id} = document.querySelector('button[data-id="#{id}"]');
            const resetButton_#{id} = document.querySelector('.code-reset[data-id="#{id}"]');
            const resultOutput_#{id} = document.querySelector('#result-#{id} .result-output');
            
            executeButton_#{id}.addEventListener('click', function() {
              const code = `#{code.gsub("'", "\\'")}`;
              const lang = "#{@language}";
              
              executeButton_#{id}.disabled = true;
              executeButton_#{id}.innerText = '执行中...';
              
              // 根据语言选择不同执行方式
              if (lang === 'javascript') {
                try {
                  // 创建一个安全的执行环境
                  const iframe = document.createElement('iframe');
                  iframe.style.display = 'none';
                  document.body.appendChild(iframe);
                  const console = { log: function() { 
                    resultOutput_#{id}.innerText += Array.from(arguments).join(' ') + '\\n';
                  }};
                  
                  iframe.contentWindow.eval(`
                    try {
                      const console = { log: parent.console.log };
                      ${code}
                    } catch(e) {
                      console.log("错误:", e.message);
                    }
                  `);
                  document.body.removeChild(iframe);
                } catch(e) {
                  resultOutput_#{id}.innerText = "执行错误: " + e.message;
                }
                executeButton_#{id}.disabled = false;
                executeButton_#{id}.innerText = '运行代码';
              } else {
                // 其他语言需要发送到后端执行
                // 注意：这需要一个后端服务来执行代码
                resultOutput_#{id}.innerText = "注意：需要设置后端API来执行此代码\\n";
                resultOutput_#{id}.innerText += "此处为模拟执行\\n\\n";
                
                // 模拟执行效果
                setTimeout(() => {
                  if (lang === 'python') {
                    resultOutput_#{id}.innerText += "Python执行结果模拟输出";
                  } else if (lang === 'ruby') {
                    resultOutput_#{id}.innerText += "Ruby执行结果模拟输出";
                  } else if (lang === 'c' || lang === 'cpp') {
                    resultOutput_#{id}.innerText += "编译中...\\n完成！\\n运行结果：\\nC/C++执行结果模拟输出";
                  }
                  executeButton_#{id}.disabled = false;
                  executeButton_#{id}.innerText = '运行代码';
                }, 1000);
              }
            });
            
            // 重置输出
            resetButton_#{id}.addEventListener('click', function() {
              resultOutput_#{id}.innerText = '';
            });
          });
        </script>
      HTML
      
      output
    end
  end
end

Liquid::Template.register_tag('execute', Jekyll::CodeExecutorTag)