require 'rubygems'
require 'pp'
require 'RMagick'

Rows = 3500
Cols = 800

fonts = Dir['/Library/Fonts/*']
fonts += Dir['/Users/aa/Library/Fonts/*']
ex = Magick::Image.new(Cols, Rows)

text = Magick::Draw.new
text.pointsize = 36

y=30;
fonts.each_with_index do |font, i|
  pp font
  next if font.index('fonts.cache')
  next if font.index('Apple')
  text.font = '/Library/Fonts/Arial' 
  text.annotate(ex, 0,0,320,y, "#{i} #{font[14..-1]}") do 
    self.fill = 'maroon'
  end
  text.font = font 
  text.annotate(ex, 0,0,-1,y, ARGV[0]) do 
    self.fill = 'maroon'
  end
  y += 30
end

ex.write('drop_shadow.png')
exit
