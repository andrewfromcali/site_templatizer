require 'rubygems'
require 'pp'
require 'RMagick'
include Magick

class Logo

  BG_COLOR = '#122246'

  def render
    logo = Magick::Image.new(800, 200) do
      self.background_color = BG_COLOR
    end
    draw_word(@word1, 0, 0, @color1, logo)
    draw_word(@word2, @met1.width+2, 0, @color2, logo)
    logo.trim!
    orig = logo.copy
    logo.flip!

    bg = Magick::Image.new(logo.columns*1, logo.rows*1.70) do
      self.background_color = BG_COLOR
    end

    mask = Magick::Image.new(1, 15)
    pixels = [Magick::Pixel.from_color("#333333"),
              Magick::Pixel.from_color("#333333"),
              Magick::Pixel.from_color("#333333"),
              Magick::Pixel.from_color("#333333"),
              Magick::Pixel.from_color("#222222"),
              Magick::Pixel.from_color("#1E1E1E"),
              Magick::Pixel.from_color("#121212"),
              Magick::Pixel.from_color("#0A0A0A"),
              Magick::Pixel.from_color("#050505"),
              Magick::Pixel.from_color("#020202"),
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
    trans = Magick::Image.new(800, 200) do
      self.background_color = "none"
    end
    draw_word(@word1, 0, 0, @color1, trans)
    draw_word(@word2, @met1.width+2, 0, @color2, trans)
    trans.trim!
    final = final.composite(trans, Magick::NorthGravity, Magick::OverCompositeOp)
    done = Magick::Image.new(final.columns*1.20, final.rows*1.20) do
      self.background_color = BG_COLOR
    end
    done = done.composite(final, Magick::SouthGravity, Magick::OverCompositeOp)
    done.write('logo.png')
  end

  def draw_word(word, x, y, color, image)
    gc = Magick::Draw.new
    gc.font = @font
    gc.gravity Magick::WestGravity
    pp @font
    gc.pointsize = @size 
    gc.fill = color
    gc.stroke = 'none'
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
    @size = 22
    gc.pointsize = @size 
    @met1 = gc.get_type_metrics(@word1)
    @met2 = gc.get_type_metrics(@word2)
    @color1 = '#ACE1AF'
    @color2 = '#FFFFFF'
  end

end

Logo.run

