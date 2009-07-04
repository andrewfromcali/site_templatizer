class SiteTemplatizer
  
  def initialize
    @images = {}
    @styles = {}
    @words = File.read('words.txt').split("\n")
    @max_words = @words.size
    @prev_node = nil
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
      @prev_node = n.name
    elsif n.kind_of?(Hpricot::Text)
      data = n.to_s.strip
      write(random_words) if data.size > 0 and @prev_node != 'script'
    end
  end
  
  def attributes(n)
    hash = n.attributes
    
    if n.name == 'img'
      download_image(hash['src'])
      hash['src'] = "images/#{@images[hash['src']]}"
    elsif n.name == 'link'
      download_css(hash['href'])
      hash['href'] = "styles/#{@styles[hash['href']]}"
    end
    
    buff = []
    hash.each do |k,v|
      buff << "#{k}=\"#{v}\""
    end
    buff.join(' ')
  end

  def read_from_cache_or_download(folder, src)
    cache_name = "cached_#{folder}/#{src.gsub(/\//,'_')}"

    if File.exists?(cache_name)
      puts "downloading #{src} CACHED"
      res = OpenStruct.new
      res.body = File.read(cache_name)
      return res, cache_name
    else
      download_src = src
      download_src = "http://www.lendingclub.com#{src}" if src.index('http://') != 0
      puts "downloading #{src}"
      url = URI.parse(download_src)
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      return res, cache_name
    end
  end

  def handle_download_and_cache(res, folder, cache_name, src)
    file = File.new(cache_name, "w")
    file << res.body
    file = File.new("#{folder}/#{src}", "w")
    file << res.body
    file.close
  end
  
  def download_css(href)
    return if @styles[href]
    res, cache_name = read_from_cache_or_download('styles', href)
    @styles[href] = "#{random_words}.css"
    handle_download_and_cache(res, 'styles', cache_name, @styles[href])

    sac = CSS::SAC::Parser.new
    sheet = sac.parse(File.read("styles/#{@styles[href]}"))

    sheet.rules_by_property.map do |properties, rules|
      items = rules.map { |rule| rule.selector.to_css }.sort
pp items
      props = properties.map do |key,value,important|
                join_val = ('font-family' == key) ? ', ' : ' '
                values = [value].flatten.join(join_val)
                {"#{key}" => "#{values}#{important ? ' !important' : ''}"}
              end
    end
  rescue Object => e
    pp e
    pp e.backtrace
  end

  def download_image(src)
    return if @images[src]
    res, cache_name = read_from_cache_or_download('images', src)
    suffix = src[-3..-1]
    @images[src] = "#{random_words}.#{suffix}"
    handle_download_and_cache(res, 'images', cache_name, @images[src])
  rescue Object => e
    pp e
    pp e.backtrace
  end
  
  def handle_close(n, tab)
    if n.kind_of?(Hpricot::Elem) and (n.children.size > 0 or n.name == 'div') and not exclude?(n)
      write("#{tab}</#{n.name}>")
    end
  end

end
