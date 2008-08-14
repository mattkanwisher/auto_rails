mysqlcmd = "-u root  --execute=\"delete from epas\" auto"
#puts mysqlcmd
%x[mysql #{mysqlcmd}]

  Dir["*.csv"].each do |file|
      #rename to epa
      newfile = "epas.csv"
      puts "Renamed to #{file} to #{newfile}\\n"
      File.rename(file, newfile)
      
      #run mysqlimport
      puts "running mysqlimport"
      fullfilepath = Dir.pwd + "/" + newfile
      puts fullfilepath
      mysqlimport = "--ignore-lines=1 --fields-optionally-enclosed-by=\"\\\"\" --fields-terminated-by=, --lines-terminated-by=\"\\n\" auto #{fullfilepath}  --columns=klass,mfr,car_line,displacement,cylnder,transmission,drive_sys,@X,city_mpg,hwy_mpg,comb_mpg,@X,@X,@X,fuel_type -u root"
      puts %x[mysqlimport #{mysqlimport}]


      #update the year
      puts "updating the year"
      fileyear = file.split(".")[0]
      mysqlcmd = "-u root  --execute=\"update epas SET year = '#{fileyear}' where year IS NULL\" auto"
      #puts mysqlcmd
      %x[mysql #{mysqlcmd}]
      
      #return to original filename
      File.rename(newfile, file)
      puts "Renamed  #{newfile} to #{file}\\n"
      
      puts ""
  end