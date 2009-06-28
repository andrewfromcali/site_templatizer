require 'rubygems'
require 'pp'
require 'RMagick'

class Logo

  def self.run
    logo = Logo.new(ARGV[0], ARGV[1], ARGV[2])
    logo.render
  end

  def initialize(font_index, word1, word2)
    fonts = Dir['/Library/Fonts/*']
    @font = fonts[font_index.to_i] 
    @word1 = word1
    @word2 = word2

    gc = Magick::Draw.new
    gc.font = @font
    gc.pointsize = 24 
    @met1 = gc.get_type_metrics(@word1)
    @met2 = gc.get_type_metrics(@word2)
    cols = @met1.width+@met2.width+30
    rows = @met1.height+20
    @image = Magick::Image.new(cols, rows) do
      self.background_color = '#282828'
    end
  end

  def draw_word(word)
    gc = Magick::Draw.new
    gc.font = @font
    gc.pointsize = 24 
    gc.fill = 'white'
    gc.text(10,30,word)
    gc.draw(@image)
  end

  def render
    draw_word(@word1)
    @image.write('logo.png')
  end

end

Logo.run


#gc.fill = '#FF9807'
#gc.text(word1.width+12,30,ARGV[2])

