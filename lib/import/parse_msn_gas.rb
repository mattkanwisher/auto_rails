require "config/environment"
require 'hpricot'

def insert_section(section, zip)
  gz  = GasZip.new()
  ll = section[0].split(",")
  gz.long = ll[0]
  gz.lat = ll[1]
  gz.parent_zip = zip
  gz.in_page_id = section[1]
  gz.gas_mini_name = section[2]
  gz.save
end

ActiveRecord::Base.connection.execute("truncate table gas_zips") 

Dir["tmp_pages/*.html"].each do |file|
  file = Dir["tmp_pages/*.html"].first
  puts file
  #imgMap
  doc = open(file) { |f| Hpricot(f) }
  ele = doc.search("//img[@id='imgMap']")
  src =  ele.first.attributes['src']
  puts src
  splits =  src.split("|")
  splits.delete_at(splits.length-1)
  splits.delete_at(0)
  count = 1
  while splits.length > 0 
    section = splits.slice!(0..4)
    insert_section(section, file.match("gas_(.*).html")[1])
  end
  
end

