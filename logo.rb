require 'rubygems'
require 'pp'
require 'RMagick'

Rows = 50
Cols = 220

fonts = Dir['/Library/Fonts/*']
ex = Magick::Image.new(Cols, Rows) do
  self.background_color = '#282828'
end

gc = Magick::Draw.new
gc.font = fonts[ARGV[0].to_i] 
gc.pointsize = 24 
#gc.stroke('white')
gc.fill('white')
gc.text(30,30, ARGV[1])

gc.draw(ex)

#text.pointsize = 36
#text.font = fonts[ARGV[0].to_i] 
#text.annotate(ex, 0,0,10,40, ARGV[1]) do 
#  self.fill = 'green'
#end
#text.annotate(ex, 0,0,10,40, ARGV[1]) do 
#  self.fill = 'green'
#end

ex.write('logo.png')
exit
