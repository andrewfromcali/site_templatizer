require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'ostruct'
require 'net/http'
require 'pp'
require 'site_templatizer.rb'

#http = Net::HTTP.new('www.cpp.com', 80)
#resp, data = http.get('/')

#f = File.new('index.html')
#data = f.read
#puts 'parsing...'

#p = HTMLTree::Parser.new(true, true)
#p.feed(data)

`rm -rf images/*`
doc = open("index.html") { |f| Hpricot(f) }
st = SiteTemplatizer.new
st.print(doc.root, '')
st.post_run



#puts doc.root.class.instance_methods
#pp doc.root.attributes
#puts doc.root.name
#pp doc.root.children.size
#(doc/"!").each do |img|
#  puts img
#end
puts 'done'
