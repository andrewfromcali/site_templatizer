require 'rubygems'
require 'pp'
require 'RMagick'


list = Magick::ImageList.new

end_color = '#b26116'

top = Magick::Image.new(1, 1)
pixels = [Magick::Pixel.from_color(end_color)]
top.store_pixels(0, 0, 1, 1, pixels)
list << top

gradient = Magick::GradientFill.new(0, 0, 1, 0, "#A74800", "#D05F01")
middle1 = Magick::Image.new(1, 7, gradient)

gradient = Magick::GradientFill.new(0, 0, 1, 0, "#d05f01", "#fb9932")
middle2 = Magick::Image.new(1, 227-7-5, gradient)

gradient = Magick::GradientFill.new(0, 0, 1, 0, "#FA9833", "#E88C2E")
bottom = Magick::Image.new(1, 5, gradient)

#mask = Magick::Image.new(1, 227)
#pixels = []
#20.times do
#  pixels << Magick::Pixel.from_color("#EEEEEE")
#end
#207.times do
#  pixels << Magick::Pixel.from_color("#FFFFFF")
#end
#mask.store_pixels(0, 0, 1, 227, pixels)
#middle.alpha Magick::ActivateAlphaChannel
#mask.alpha Magick::DeactivateAlphaChannel
#middle.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)

list << middle1
list << middle2
list << bottom
list << top.copy
full = list.append(true)
full.write('site1/images/serve-deloul.png')

