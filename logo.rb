require 'rubygems'
require 'pp'
require 'RMagick'
include Magick

class Logo

  def render
    base = Magick::Image.new(@met1.width+@met2.width+15, @met1.height) do
      self.background_color = 'none'
    end
    w = base.columns
    h = base.rows
    draw_word(@word1, 10, 20, 'white', base)
    draw_word(@word2, @met1.width+12, 20, '#FF9807', base)

    mirror = base.rotate(180).flop.crop(0, 0, w, h * 0.65)

    grad = GradientFill.new(0, 0, w, 0, "black", "gray35")
    opacity_mask = Image.new(w, h, grad)
    mirror.matte = true
    opacity_mask.matte = false
    mirror.composite!(opacity_mask, CenterGravity, CopyOpacityCompositeOp)

    gc = Magick::Draw.new
    gc.composite(0, 30, 0, 0, mirror)
    gc.draw(@image)

    gc = Magick::Draw.new
    gc.composite(0, 16, 0, 0, base)
    gc.draw(@image)
    @image.write('logo.png')
  end

  def draw_word(word, x, y, color, image)
    gc = Magick::Draw.new
    gc.font = @font
    gc.pointsize = 24 
    gc.fill = color
    gc.stroke = 'transparent'
    gc.text(x,y,word)
    gc.draw(image)
  end

  def self.run
    logo = Logo.new(ARGV[0], ARGV[1], ARGV[2])
    logo.render
  end

  def initialize(font_index, word1, word2)
    fonts = Dir['/Library/Fonts/*']
    fonts += Dir['/Users/aa/Library/Fonts/*']
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

