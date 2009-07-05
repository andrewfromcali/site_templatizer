require 'rubygems'
require 'pp'
require 'RMagick'
include Magick

image = Magick::Image::read('me.jpg').first
image.border!(18, 18, "#f0f0ff")

image.background_color = "none"

amplitude = image.columns * 0.01
wavelength = image.rows  * 2

image.rotate!(90)
image = image.wave(amplitude, wavelength)
image.rotate!(-90)

shadow = image.flop
shadow = shadow.colorize(1, 1, 1, "gray75")
shadow.background_color = "none"
shadow.border!(10, 10, "none")
shadow = shadow.blur_image(0, 3)

image = shadow.composite(image, -amplitude/2, 5, Magick::OverCompositeOp)
image.rotate!(-5)
image.trim!
image.alpha(ActivateAlphaChannel)

image.write('site1/images/me_p.png')

