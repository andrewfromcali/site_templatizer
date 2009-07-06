require 'rubygems'
require 'pp'
require 'RMagick'
include Magick

light = '#FF7E00'
med = 'orange'
dark = '#D2691E'

light = '#248A95'
med = '#07484E'
dark = '#053D44'

image = Image.new(212, 159)

list = ImageList.new
horz = ImageList.new
fill = GradientFill.new(0, 0, 0, 46, med, light)
horz << Image.new(46, 70, fill)
fill = GradientFill.new(0, 0, 0, 160, light, med)
horz << Image.new(160, 70, fill)
list << horz.append(false)

image = Image.new(206, 42) do
  self.background_color = dark
end
list << image
image = Image.new(206, 1) do
  self.background_color = med 
end
list << image
image = Image.new(206, 10) do
  self.background_color = dark 
end
list << image
fill = GradientFill.new(0, 0, 206, 0, dark, light)
list << Image.new(206, 30, fill)

final = list.append(true)
final.border!(3, 3, "none")

gc = Draw.new
gc.stroke = 'white'
gc.fill = 'none'
gc.stroke_width(3)
gc.roundrectangle(1,1,210,155, 5, 5)
gc.draw(final)

def t(txt, size, font, x, y, image)
  gc = Magick::Draw.new
  gc.pointsize = size 
  gc.font = font
  gc.fill = 'black'
  gc.stroke = 'none'
  gc.text(x+2,y+2,txt)
  gc.draw(image)
  gc = Magick::Draw.new
  gc.font = font 
  gc.pointsize = size 
  gc.fill = 'white'
  gc.stroke = 'none'
  gc.text(x,y,txt)
  gc.draw(image)
end

f1 = '/Library/Fonts/Arial Rounded Bold'
t('Get Story Coverage', 18, f1, 14, 29, final)

gc = Magick::Draw.new
gc.font = 'Veranda'
gc.pointsize = 14 
gc.fill = 'white'
gc.stroke = 'none'
gc.text(14,51,'A professional review of')
gc.draw(final)

gc = Magick::Draw.new
gc.font = 'Veranda'
gc.pointsize = 14 
gc.fill = 'white'
gc.stroke = 'none'
gc.text(14,65,'your novel or screenplay')
gc.draw(final)

t('$99', 28, f1, 22, 107, final)

final.write('../site1/images/ad.png')
