require 'rubygems'
require 'pp'
require 'RMagick'

include Magick

w = WIDTH = 650
h = HEIGHT = 80


bg = Image.new(w, h) do
  self.background_color = "#282828"
end
reflection = Image.new(230, 60) do
  self.background_color = "#282828"
end

gc = Draw.new
gc.fill = 'white'
gc.stroke = 'none'
gc.pointsize = 42
gc.font = '/Users/aa/Library/Fonts/CHICM___.TTF'

#gc.annotate(bg, 0, 0, 70, HEIGHT, "Lending Club")

#reflection = stripes[1]#.flip
#reflection.composite!(color, CenterGravity, ColorizeCompositeOp)
gc.annotate(reflection, 0, 0, 10, 50, "Lending Club")
reflection.flip!
reflection.crop!(0,0,230,33)
grad = GradientFill.new(0, 0, 100, 0, "#900", "#000")
opacity_mask = Image.new(230,33, grad)

reflection.matte = true
opacity_mask.matte = false
reflection.composite!(opacity_mask, NorthGravity, CopyOpacityCompositeOp)

bg.composite!(reflection, SouthGravity, OverCompositeOp)

fill = Magick::GradientFill.new(0, 0, 1, 0, "#443724", "#282828")
img = Magick::Image.new(100, 20, fill);
img.write('test.png')
