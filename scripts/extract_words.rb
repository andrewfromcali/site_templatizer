File.open('/usr/share/dict/words').each do |line|
  line = line.strip
  next if line.size > 7
  next if line.size < 3
  next if line[0] <= 90
  puts line
end
