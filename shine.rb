require 'rubygems'
require 'RMagick'

logo = Magick::Image.read('logo.png').first

# Draw a mask that will round the corners of the image.
# Stroke the mask using a gradient that is black at the
# top and white at the bottom. Fill the mask with plain white.

round_corners_mask = Magick::Image.new(logo.columns, logo.rows) {self.background_color = "black"}
round_corners_gradient = Magick::Image.read("gradient:black-white")  {self.size = "#{logo.columns}x#{logo.rows}" }.first

# Draw a rounded rectangle that is slightly smaller
# than the image. Center the rectangle right-to-left.

gc = Magick::Draw.new
gc.pattern("round_corners", 0, 0, logo.columns, logo.rows) do
   gc.composite(0, 0, 0, 0, round_corners_gradient)
end
gc.fill("white")
gc.stroke_width(4)
gc.stroke("round_corners")
gc.roundrectangle(2, 0, logo.columns-4,logo.rows-4, 36, 36)
gc.draw(round_corners_mask)

# Use the mask to create a copy of the logo with rounded corners.
round_corners_mask.alpha(Magick::DeactivateAlphaChannel)
logo.alpha(Magick::ActivateAlphaChannel)
rounded = logo.composite(round_corners_mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)

# Create a gradient that is opaque white at the top, transparent white at the bottom.
# The gradient should be the same width as the logo but only half the height.
shine_gradient = Magick::Image.read("gradient:#ffffffcf-#ffffff10") {self.size = "#{logo.columns}x#{logo.rows/2.0}" }.first

# Using the gradient as a fill, draw an ellipse over the top half
# of the image. This puts the "shine" over the upper half of the image.
gc = Magick::Draw.new
gc.pattern("shine", 0, 0, logo.columns, logo.rows) do
   gc.composite(0, 0, 0, 0, shine_gradient)
end
gc.fill("shine")
gc.stroke("none")
gc.ellipse(logo.columns/2.0, 0, logo.columns,logo.rows/2.0, 0, 360)
gc.draw(rounded)

# At this point, the edges and corners of the rounded image are
# transparent. Here we composite it over a plain white background.
# If you want a transparent image, skip this step.
bg = Magick::Image.new(logo.columns, logo.rows)
shine = bg.composite(rounded, Magick::CenterGravity, Magick::OverCompositeOp)

# Write the image to a file in JPEG format.
shine.write("rm_shine.jpg")

# If you need to run this code over many images without terminating the Ruby process
# (i.e. in a web server) destroy all the images so they won't be using up memory.
# If this is just a one-shot script, you can skip this part.
round_corners_gradient.destroy!
round_corners_mask.destroy!
shine_gradient.destroy!
logo.destroy!
bg.destroy!
rounded.destroy!
shine.destroy!
