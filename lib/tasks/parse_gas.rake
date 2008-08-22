desc "pase the gas data from msn "
task :gas_parse => :environment do
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

  def parseimagemap(ele, zip)
    src =  ele.first.attributes['src']
    #puts src
    splits =  src.split("|")
    splits.delete_at(splits.length-1)
    splits.delete_at(0)
    count = 1
    while splits.length > 0 
      section = splits.slice!(0..4)
      insert_section(section, zip)
    end
  end

  def parselocalavg(ele, zipc)
    images = ele.search("/img") 
    x1 =  images[2].attributes['src'].match("gasprice-(.*).gif")[1]
    x2 =  images[4].attributes['src'].match("gasprice-(.*).gif")[1]
    x3 =  images[5].attributes['src'].match("gasprice-(.*).gif")[1]
    price = "#{x1}.#{x2}#{x3}"
    puts "price-#{price}"
    zip = ZipCode.find(zipc)
    if(zip)
      zip.avg_price = price
      zip.save
    else
      puts "Zip not found ! #{zip}"
    end
  end
  
  def parse_gas_stations_table(ele, zip)
    ele.search("//tr").each_with_index do |tr, index|
        if( index != 0)
          tds =  tr.search("/td")
          station_id = tds[0].search("a").first.attributes['href'].match("ico=(.*)&m")[1]
          spans  = tds[2].search("//span")
          address1 =  spans[0].innerHTML
          address2 =  spans[1].innerHTML
          
        
          gas_station = GasZip.find(:first, :conditions => { :parent_zip => zip, :in_page_id => station_id})
          if( gas_station == nil)
            puts "ERROR TRYING TO LOCATE A GAS STATION"
          else
            gas_station.address1 = address1
            gas_station.address2 = address2
            gas_station.save
          end
        end
    end
  end


  ActiveRecord::Base.connection.execute("truncate table gas_zips") 

  Dir["tmp_pages/*.html"].each do |file|
    #file = Dir["tmp_pages/*.html"].first
    puts file
    zip = file.match("gas_(.*).html")[1]
    #imgMap
    doc = open(file) { |f| Hpricot(f) }
    ele = doc.search("//img[@id='imgMap']")
    if(ele.first.attributes['src'].include?("gasprice-mapNA.gif"))
      puts "INVALID ZIP!"
    else
      parseimagemap(ele, zip)
      ele = doc.search("//td[@id='LocalAvg']")
      parselocalavg(ele, zip)
      ele = doc.search("//table[@id='tblDetail']")
      parse_gas_stations_table(ele,zip)
    end
  end
end