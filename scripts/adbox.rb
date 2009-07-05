require 'rubygems'
require 'pp'
require 'RMagick'
include Magick

light = '#FF7E00'
med = 'orange'
dark = '#D2691E'

image = Image.new(212, 159)
list = ImageList.new
fill = GradientFill.new(0, 0, 0, 159, med, light)
list << Image.new(206, 60, fill)
image = Image.new(206, 52) do
  self.background_color = dark
end
list << image
image = Image.new(206, 1) do
  self.background_color = light
end
list << image
fill = GradientFill.new(0, 0, 206, 0, dark, light)
list << Image.new(206, 40, fill)

final = list.append(true)
final.border!(3, 3, "none")

gc = Draw.new
gc.stroke = 'white'
gc.fill = 'none'
gc.stroke_width(3)
gc.roundrectangle(1,1,210,155, 5, 5)
gc.draw(final)

final.write('../site1/images/ad.png')
