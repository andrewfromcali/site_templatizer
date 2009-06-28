require 'rubygems'
require 'pp'
require 'RMagick'

class Logo

  def grad(color, w, h)
    grad = Magick::Image.read("gradient:#{color}") do
      self.size = "#{w}x#{h}"
    end
    grad.first
  end

  def do_pattern(name, w, h, grad, color, image)
    gc = Magick::Draw.new
    gc.pattern(name, 0, 0, w, h) do
      gc.composite(0, 0, 0, 0, grad)
    end
    gc.fill(color)
    gc.stroke(name)
    gc.rectangle(0, 0, w, h)
    gc.draw(image)
  end

  def render
    mirror = Magick::Image.new(@met1.width+@met2.width+15, @met1.height) do
      self.background_color = 'none'
    end
    w = mirror.columns
    h = mirror.rows
    draw_word(@word1, 10, 20, 'white', mirror)
    draw_word(@word2, @met1.width+12, 20, '#FF9807', mirror)
    gc = Magick::Draw.new
    gc.composite(0, 10, 0, 0, mirror)
    gc.draw(@image)

    mirror = mirror.rotate(180).flop

    g1 = grad('black-white', mirror.columns, mirror.rows)
    g2 = grad('#ffffffcf-#ffffff10', mirror.columns, mirror.rows)

    mask1 = Magick::Image.new(w, h)
    do_pattern('p1', w, h, g1, 'white', mask1)
    mask1.alpha(Magick::DeactivateAlphaChannel)
    mirror.alpha(Magick::ActivateAlphaChannel)
    rounded = mirror.composite(mask1, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
    do_pattern('p2', w, h, g2, nil, rounded)
    
    gc = Magick::Draw.new
    gc.composite(0, 33, 0, 0, rounded)
    gc.draw(@image)
    @image.write('logo.png')
  end

  def draw_word(word, x, y, color, image)
    gc = Magick::Draw.new
    gc.font = @font
    gc.pointsize = 24 
    gc.fill = color
    gc.text(x,y,word)
    gc.draw(image)
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

