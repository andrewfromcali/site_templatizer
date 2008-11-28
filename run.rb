require 'rubygems'
require 'pp'
require 'net/http'
require 'mechanize'
require 'html/tree'
require 'RMagick'
require 'site_templatizer.rb'

#http = Net::HTTP.new('www.cpp.com', 80)
#resp, data = http.get('/')

f = File.new('index.html')
data = f.read
puts 'parsing...'

p = HTMLTree::Parser.new(true, false)
p.feed(data)

st = SiteTemplatizer.new
st.print(p.html, '')
st.post_run
puts 'done'
