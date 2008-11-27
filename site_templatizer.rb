class SiteTemplatizer

  def initialize
  end

  def print(node, tab)
  
    node.children.each do |n|
      if n.kind_of?(HTMLTree::Element)
        if n.children.size > 0
          puts "#{tab}<#{n.tag}"
        else
          puts "#{tab}<#{n.tag} />"
        end
      end
      print(n, " #{tab}")
      if n.kind_of?(HTMLTree::Element) and n.children.size > 0
        puts "#{tab}</#{n.tag}>"
      end
    end

  end

end