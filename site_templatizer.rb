class SiteTemplatizer
  include Magick
  
  EXCLUDE = ['script', 'link']

  def initialize
    @images = {}
    @output = File.new('test.html', "w")
  end
  
  def post_run
    @output.close
  end

  def print(node, tab)
  
    node.children.each do |n|
      handle_open(n, tab)
      print(n, " #{tab}")
      handle_close(n, tab)
    end

  end
  
  def handle_open(n, tab)
    if n.kind_of?(HTMLTree::Element) and not EXCLUDE.include?(n.tag)
      line = "#{tab}<#{n.tag} #{attributes(n)}"
      if n.children.size > 0 or n.tag == 'div'
        line = line + '>'
      else
        line = line + ' />'
      end
      @output << line
    elsif n.kind_of?(HTMLTree::Data)
      data = n.to_s.strip
      @output << 'data' if data.size > 0
    end
  end
  
  def attributes(n)
    hash = n.attributes
    
    if (n.tag == 'img')
      download_image(hash['src'])
      hash['src'] = "images/#{@images[hash['src']]}.png"
    end
    
    buff = []
    hash.each do |k,v|
      buff << "#{k}=\"#{v}\""
    end
    buff.join(' ')
  end
  
  def download_image(src)
    return if @images[src]
    puts "downloading #{src}"
    url = URI.parse(src)
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    @images[src] = @images.size
    name = @images[src]
    suffix = src[-3..-1]
    file = File.new("images/orig/#{name}.#{suffix}", "w")
    file << res.body
    file.close
    orig = ImageList.new("images/orig/#{name}.#{suffix}").first
    placeholder = Image.new(orig.columns, orig.rows) { self.background_color = "blue" }
    placeholder.write("images/#{name}.png")
  rescue Object => e
    pp e
  end
  
  def handle_close(n, tab)
    if n.kind_of?(HTMLTree::Element) and (n.children.size > 0 or n.tag == 'div') and not EXCLUDE.include?(n.tag)
      @output << "#{tab}</#{n.tag}>"
    end
  end

end