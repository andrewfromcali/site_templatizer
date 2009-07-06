require 'rubygems'
require 'pp'
require 'RMagick'
include Magick

light = '#248A95'
med = '#07484E'
dark = '#053D44'

light = '#958A24'
med = '#4E4807'
dark = '#443D05'

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

def t(txt, size, font, x, y, image, drop=true)
  if drop
    gc = Magick::Draw.new
    gc.pointsize = size 
    gc.font = font
    gc.fill = 'black'
    gc.stroke = 'none'
    gc.text(x+2,y+2,txt)
    gc.draw(image)
  end
  gc = Magick::Draw.new
  gc.font = font 
  gc.pointsize = size 
  gc.fill = 'white'
  gc.stroke = 'none'
  gc.text(x,y,txt)
  gc.draw(image)
end

f1 = '/Library/Fonts/Arial Rounded Bold'
#t('Get Story Coverage', 18, f1, 14, 29, final)
t('Actor Headshots', 18, f1, 14, 29, final)

f2 = 'Veranda'
#t('A professional review of', 14, f2, 14, 51, final, false)
#t('your novel or screenplay', 14, f2, 14, 65, final, false)
t('Latest digital camera to', 14, f2, 14, 51, final, false)
t('capture the look you want', 14, f2, 14, 65, final, false)

#t('$99', 28, f1, 20, 105, final)
#t('Thorough 3 page', 14, f2, 80, 92, final)
#t('review!', 14, f2, 80, 107, final)
t('$80', 28, f1, 20, 105, final)
t('Two hour shoot', 14, f2, 80, 92, final)
t('See proofs online', 14, f2, 80, 107, final)

gc = Magick::Draw.new
gc.fill = 'none'
gc.stroke = light 
gc.fill = dark
gc.rectangle(11, 123, 125, 146)
gc.draw(final)

t('LEARN MORE >>', 12, f2, 20, 140, final, false)

final.write('../site1/images/ad2.png')
