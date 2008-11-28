require 'rubygems'
require 'pp'
require 'net/http'
require 'mechanize'
require 'html/tree'
require 'site_templatizer.rb'

http = Net::HTTP.new('www.cnn.com', 80)
resp, data = http.get('/')

#data = []
#File.open('index.html').each do |line|
#  data << line
#end

p = HTMLTree::Parser.new(true, false)
p.feed(data)

st = SiteTemplatizer.new
st.print(p.html, '')
st.post_run