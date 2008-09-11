desc "import the gas data from msn "
task :gas_import => :environment do

  def download_file(zip)
    %x[wget -Otmp_pages/gas_#{zip}.html 'http://autos.msn.com/everyday/GasStations.aspx?m=1&l=1&zip=#{zip}&x=0&y=0']
  end

  zips = ZipCode.find(:all, :conditions => "state <> 'PR'")

  zips.each_with_index do |zip, index|
    puts "zip -#{zip.id}"
    download_file(zip.id)
#    if index > 100
#      break
#    end
  end

end


desc "pase the gas data from msn "
task :gas_parse => :environment do
  puts "parse gas"
end