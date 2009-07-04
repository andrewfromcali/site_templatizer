require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'ostruct'
require 'net/http'
require 'csspool'
require 'pp'
require 'site_templatizer.rb'

`rm -rf images/*`
`rm -rf styles/*`
doc = open("index.html") { |f| Hpricot(f) }
st = SiteTemplatizer.new
st.print(doc.root, '')
st.post_run

puts 'done'
