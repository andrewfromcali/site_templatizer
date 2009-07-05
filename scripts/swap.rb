require 'rubygems'
require 'pp'
require 'RMagick'
include Magick

image = Magick::Image::read('lobster-tuilyie.gif').first

pixels = []
image.get_pixels(0, 0, image.columns, image.rows).each do |p|
  #hex = p.to_color(AllCompliance, false, 8, true)
  #r = hex[1..2]
  #g = hex[3..4]
  #b = hex[5..-1]
  newp = Pixel.new(p.blue, p.green, p.red, p.opacity)
  pixels << newp
end

fixed = Magick::Image.new(image.columns, image.rows)
fixed.alpha(ActivateAlphaChannel)
fixed.store_pixels(0, 0, image.columns, image.rows, pixels)
fixed.write('lobster-tuilyie.png')
