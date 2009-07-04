class SiteTemplatizer
  include Magick
  
  def initialize
    @images = {}
    @styles = {}
    @words = File.read('words.txt').split("\n")
    @max_words = @words.size
    @output = File.new('test.html', "w")
    write('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">')
    write('<html>')
  end
  
  def post_run
    write('</html>')
    @output.close
  end

  def write(s)
    @output << "#{s}\n"
  end

  def random_word
    @words[rand(@max_words)]
  end

  def random_words
    "#{random_word}-#{random_word}"
  end

  def print(node, tab)
    return if node.kind_of?(Hpricot::Text) or node.kind_of?(Hpricot::Comment)
    node.children.each do |n|
      handle_open(n, tab)
      print(n, " #{tab}")
      handle_close(n, tab)
    end

  end
  
  def exclude?(n)
    return true if n.name == 'script'
    
    return true if n.name == 'link' and n.attributes['type'] != 'text/css'
      
    return false
  end
  
  def handle_open(n, tab)
    if n.kind_of?(Hpricot::Elem) and not exclude?(n)
      line = "#{tab}<#{n.name} #{attributes(n)}"
      if n.children.size > 0 or n.name == 'div'
        line = line + '>'
      else
        line = line + ' />'
      end
      write(line)
    elsif n.kind_of?(Hpricot::Text)
      data = n.to_s.strip
      write('data') if data.size > 0
    end
  end
  
  def attributes(n)
    hash = n.attributes
    
    if n.name == 'img'
      download_image(hash['src'])
      hash['src'] = "images/#{@images[hash['src']]}"
    elsif n.name == 'link'
      #download_css(hash['href'])
      hash['href'] = "styles/#{@styles[hash['src']]}.css"
    end
    
    buff = []
    hash.each do |k,v|
      buff << "#{k}=\"#{v}\""
    end
    buff.join(' ')
  end
  
  def download_css(href)
    return if @styles[href]
    puts "downloading #{href}"
    url = URI.parse(href)
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    @styles[href] = @styles.size
    name = @styles[href]
    file = File.new("styles/orig/#{name}.css", "w")
    file << res.body
    file.close
    file = File.new("styles/#{name}.css", "w")
    file << res.body
    file.close
  rescue Object => e
    pp e
  end

  def download_image(src)
    return if @images[src]
    download_src = src
    download_src = "http://www.lendingclub.com#{src}" if src.index('http://') != 0
    puts "downloading #{src}"
    url = URI.parse(download_src)
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    suffix = src[-3..-1]
    @images[src] = "#{random_words}.#{suffix}"
    file = File.new("images/#{@images[src]}", "w")
    file << res.body
    file.close
  rescue Object => e
    pp e
  end
  
  def handle_close(n, tab)
    if n.kind_of?(Hpricot::Elem) and (n.children.size > 0 or n.name == 'div') and not exclude?(n)
      write("#{tab}</#{n.name}>")
    end
  end

end
