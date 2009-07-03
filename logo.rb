require 'rubygems'
require 'pp'
require 'RMagick'
include Magick

class Logo

  def render
    logo = Magick::Image.new(800, 200) do
      self.background_color = "#282828"
    end
    draw_word(@word1, 0, 'white', logo)
    draw_word(@word2, @met1.width+2, '#FF9807', logo)
    logo.trim!
    logo.flip!

    bg = Magick::Image.new(logo.columns*1.20, logo.rows*2.00) do
      self.background_color = "#282828"
    end

    mask = Magick::Image.new(1, 15)
    pixels = [Magick::Pixel.from_color("#1f1f1f"),
              Magick::Pixel.from_color("#1c1c1c"),
              Magick::Pixel.from_color("#181818"),
              Magick::Pixel.from_color("#141414"),
              Magick::Pixel.from_color("#0F0F0F"),
              Magick::Pixel.from_color("#0B0B0B"),
              Magick::Pixel.from_color("#080808"),
              Magick::Pixel.from_color("#050505"),
              Magick::Pixel.from_color("#020202"),
              Magick::Pixel.from_color("#000000"),
              Magick::Pixel.from_color("#000000"),
              Magick::Pixel.from_color("#000000"),
              Magick::Pixel.from_color("#000000"),
              Magick::Pixel.from_color("#000000"),
              Magick::Pixel.from_color("#000000"),
              Magick::Pixel.from_color("#000000")]
    mask.store_pixels(0, 0, 1, 15, pixels)
    mask.scale!(logo.columns, logo.rows)

    logo.alpha Magick::ActivateAlphaChannel
    mask.alpha Magick::DeactivateAlphaChannel
    logo.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)

    final = bg.composite(logo, Magick::SouthGravity, Magick::OverCompositeOp)

    final.write('logo.png')
  end

  def draw_word(word, x, color, image)
    gc = Magick::Draw.new
    gc.font = @font
    gc.gravity Magick::WestGravity
    pp @font
    gc.pointsize = @size 
    gc.fill = color
    gc.stroke = 'none'
    gc.text(x,0,word)
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
    @size = 72
    gc.pointsize = @size 
    @met1 = gc.get_type_metrics(@word1)
    @met2 = gc.get_type_metrics(@word2)
  end

end

Logo.run

