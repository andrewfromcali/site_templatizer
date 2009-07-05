require 'rubygems'
require 'pp'
require 'RMagick'

logo = Magick::ImageList.new
logo << Magick::Image.new(800, 200) {self.background_color = "#282828"}

# We're going to draw the words "Lending Club" in three pieces, "Lendin", "g",
# and "Club". Measure the width of the first 2 pieces so we know where to draw the
# 2nd and 3rd piece. Measure "Lendin" + "g" using the same font and font size
# that we'll use when we draw "Lending".
gc = Magick::Draw.new
gc.pointsize = 96
gc.font = "Arial-Black-Regular"
lendin_metrics = gc.get_type_metrics "Lendin"
g_metrics = gc.get_type_metrics "g"


# Draw "Lending Club". Start over with a new Draw object
gc = Magick::Draw.new

# Start drawing at the left. Use the same font and font size as before.
gc.gravity Magick::WestGravity
gc.pointsize 96
gc.font "Arial-Black-Regular"

# Draw "Lendin" in white
gc.stroke "none"
gc.fill "white"
gc.text 0, 0, "Lendin"

# Draw "g" 17 pixels up so that it's descender is near the baseline of the
# rest of the text. I got 17 pixels by trial-and-error.
gc.text lendin_metrics.width, -17, "g"

# Draw "Club" in orange starting 3 pixels to the right of the "g".
gc.fill "orange"
gc.text lendin_metrics.width+g_metrics.width+3, 0, "Club"

gc.draw logo

# Trim off the excess black border, make a copy, and flip the copy so it's upside-down.
logo.trim!
logo << logo[0].copy
logo[1].flip!


# Draw a gradient mask that's mostly black. Black pixels will become transparent,
# dark-gray pixels will become mostly transparent.
gradient = Magick::GradientFill.new(0, 0, logo[1].columns, 0, "gray15", "black")
mask = Magick::Image.new(logo[1].columns, logo[1].rows, gradient)

# Create a step-wise gradient. Start with a 1x6 image, then scale to the
# desired size.
mask = Magick::Image.new(1, 6)
pixels = [Magick::Pixel.from_color("#1c1c1c"),
         Magick::Pixel.from_color("#181818"),
         Magick::Pixel.from_color("#141414"),
         Magick::Pixel.from_color("#101010"),
         Magick::Pixel.from_color("#080808"),
         Magick::Pixel.from_color("#000000"),]
mask.store_pixels(0, 0, 1, 6, pixels)
mask.scale!(logo[1].columns, logo[1].rows)
#mask.write("logo.png")

# Use CopyOpacityCompositeOp to add an alpha channel to the upside-down copy of
# the logo.
logo[1].alpha Magick::ActivateAlphaChannel
mask.alpha Magick::DeactivateAlphaChannel
logo[1].composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)

# Append the upside-down copy to the rightside-up copy
result = logo.append(true)

# Make a background image that's 20% bigger than the logo.
black_bg = Magick::Image.new(result.columns*1.20, result.rows*1.20) {self.background_color = "#282828"}

# Composite the logo over the background.
final = black_bg.composite(result, Magick::CenterGravity, Magick::OverCompositeOp)

# We're done!
final.write("logo.png")
