# MathJax 数学公式支持插件

module Jekyll
  class MathJaxBlock < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @display_mode = (markup.strip == 'display')
    end

    def render(context)
      content = super.strip
      
      # 在页面头部添加 MathJax 依赖
      context.registers[:page]["head_scripts"] ||= []
      unless context.registers[:page]["head_scripts"].include?('https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js')
        mathjax_config = <<~SCRIPT
          <script>
          MathJax = {
            tex: {
              inlineMath: [['$', '$'], ['\\\\(', '\\\\)']],
              displayMath: [['$$', '$$'], ['\\\\[', '\\\\]']],
              processEscapes: true
            },
            options: {
              skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre']
            }
          };
          </script>
          <script type="text/javascript" id="MathJax-script" async
            src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">
          </script>
        SCRIPT
        context.registers[:page]["head_scripts"] << mathjax_config
      end
      
      if @display_mode
        "$$#{content}$$"
      else
        "$#{content}$"
      end
    end
  end
end

Liquid::Template.register_tag('math', Jekyll::MathJaxBlock)