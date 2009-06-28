require 'rubygems'
require 'pp'
require 'RMagick'

class Logo

  def render
    draw_word(@word1, 10, 30, 'white')
    draw_word(@word2, @met1.width+12, 30, '#FF9807')

    mask = Magick::Image.new(@image.columns, 20)
    gc = Magick::Draw.new
    gc.composite(0, 0, 0, 0, @image.crop(0,10, @image.columns, 30))
    gc.draw(mask)

    gc = Magick::Draw.new
    gc.composite(0, 30, 0, 0, mask.rotate(180).flop)
    gc.draw(@image)
    @image.write('logo.png')
  end

  def draw_word(word, x, y, color)
    gc = Magick::Draw.new
    gc.font = @font
    gc.pointsize = 24 
    gc.fill = color
    gc.text(x,y,word)
    gc.draw(@image)
  end

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
    rows = @met1.height+40
    @image = Magick::Image.new(cols, rows) do
      self.background_color = '#282828'
    end
  end

end

Logo.run

