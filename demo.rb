require 'rubygems'
require 'pp'
require 'RMagick'

include Magick

WIDTH = 650
HEIGHT = 40

stripes = ImageList.new


top_grad = GradientFill.new(0, 0, WIDTH, 0, "#dddddd", "#888888")
stripes << Image.new(WIDTH, HEIGHT, top_grad)

bottom_grad = GradientFill.new(0, 0, WIDTH, 0, "#757575", "#555555")
stripes << Image.new(WIDTH, HEIGHT, bottom_grad)

combined_grad = stripes.append(true)

color = Image.new(combined_grad.columns, combined_grad.rows) do
  self.background_color = "#87a5ff"
end

background = combined_grad.composite(color, CenterGravity, ColorizeCompositeOp)

gc = Draw.new
gc.fill = 'white'
gc.stroke = 'none'
gc.pointsize = 42

gc.annotate(background, 0, 0, 70, HEIGHT, "RMAGICK")

reflection = stripes[1].flip
reflection.composite!(color, CenterGravity, ColorizeCompositeOp)
gc.annotate(reflection, 0, 0, 70, HEIGHT, "RMAGICK")
grad = GradientFill.new(0, 0, WIDTH, 0, "black", "gray35")
opacity_mask = Image.new(WIDTH, HEIGHT, grad)

reflection.matte = true
opacity_mask.matte = false
reflection.composite!(opacity_mask, CenterGravity, CopyOpacityCompositeOp)

reflection.flip!
background.composite!(reflection, SouthWestGravity, OverCompositeOp)

background.write('test.png')
