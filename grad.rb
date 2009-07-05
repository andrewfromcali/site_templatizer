require 'rubygems'
require 'pp'
require 'RMagick'


list = Magick::ImageList.new

end_color = '#B26116'
g1 = '#A74800'
g2 = '#D05F01'
g3 = '#D05F01'
g4 = '#FB9932'
g5 = '#FA9833'
g6 = '#E88C2E'

end_color = '#1661B2'
g1 = '#0048A7'
g2 = '#015FD0'
g3 = '#015FD0'
g4 = '#3299FB'
g5 = '#3299FB'
g6 = '#2E8CE8'


preview = Magick::ImageList.new
preview << Magick::Image.new(100, 50) { self.background_color = end_color }
preview << Magick::Image.new(100, 50) { self.background_color = g1 }
preview << Magick::Image.new(100, 50) { self.background_color = g2 }
preview << Magick::Image.new(100, 50) { self.background_color = g3 }
preview << Magick::Image.new(100, 50) { self.background_color = g4 }
preview << Magick::Image.new(100, 50) { self.background_color = g5 }
preview << Magick::Image.new(100, 50) { self.background_color = g6 }
pfull = preview.append(true)
#pfull.write('preview.png')

top = Magick::Image.new(1, 1)
pixels = [Magick::Pixel.from_color(end_color)]
top.store_pixels(0, 0, 1, 1, pixels)
list << top

gradient = Magick::GradientFill.new(0, 0, 1, 0, g1, g2)
middle1 = Magick::Image.new(1, 7, gradient)

gradient = Magick::GradientFill.new(0, 0, 1, 0, g3, g4)
middle2 = Magick::Image.new(1, 227-7-5, gradient)

gradient = Magick::GradientFill.new(0, 0, 1, 0, g5, g6)
bottom = Magick::Image.new(1, 5, gradient)

list << middle1
list << middle2
list << bottom
list << top.copy
full = list.append(true)
full.write('site1/images/serve-deloul.png')


list = Magick::ImageList.new
gradient = Magick::GradientFill.new(0, 0, 1, 0, '#0479ff', '#0799ff')
list << Magick::Image.new(1, 25, gradient)
list << Magick::Image.new(1, 3)

list.append(true).write('site1/images/crosa-retinal.png')
