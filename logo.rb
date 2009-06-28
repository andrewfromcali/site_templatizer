require 'rubygems'
require 'pp'
require 'RMagick'

fonts = Dir['/Library/Fonts/*']
gc = Magick::Draw.new
gc.font = fonts[ARGV[0].to_i] 
gc.pointsize = 24 
word1 = gc.get_type_metrics(ARGV[1])
word2 = gc.get_type_metrics(ARGV[2])
cols = word1.width+word2.width+30
rows = word1.height+20

ex = Magick::Image.new(cols, rows) do
  self.background_color = '#282828'
end

gc = Magick::Draw.new
gc.font = fonts[ARGV[0].to_i] 
gc.pointsize = 24 
gc.fill = 'white'
gc.text(10,30,ARGV[1])
gc.text(word1.width+12,30,ARGV[2])
gc.draw(ex)

ex.write('logo.png')
exit
