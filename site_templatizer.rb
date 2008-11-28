class SiteTemplatizer

  def initialize
    @hash = {}
  end
  
  def post_run
  end

  def print(node, tab)
  
    node.children.each do |n|
      handle_open(n, tab)
      print(n, " #{tab}")
      handle_close(n, tab)
    end

  end
  
  def handle_open(n, tab)
    if n.kind_of?(HTMLTree::Element)
      line = "#{tab}<#{n.tag}"
      if n.children.size > 0
        line = line + '>'
      else
        line = line + ' />'
      end
      puts line
    elsif n.kind_of?(HTMLTree::Data)
      data = n.to_s.strip
      puts 'data' if data.size > 0
    end
  end
  
  def handle_close(n, tab)
    if n.kind_of?(HTMLTree::Element) and n.children.size > 0
      puts "#{tab}</#{n.tag}>"
    end
  end

end