class GasZip < ActiveRecord::Base
  def self.find_near_lat_long(latitude, longitude)
      distance = 10
      find_by_sql "SELECT * FROM zip_codes WHERE (3958*3.1415926*sqrt( (lat-#{latitude})*(lat-#{latitude})  + cos(lat/57.29578)*cos(#{latitude}/57.29578)*(longitude-#{longitude})*(longitude-#{longitude}) )/180  ) <= #{distance}"
  end
end
