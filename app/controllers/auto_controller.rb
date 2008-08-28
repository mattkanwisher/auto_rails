class AutoController < ApplicationController
   def search
      if(params["model"] == nil || params["model"].include?("model") || params["mfr"].include?("mfr"))
        render :partial => "failure"
        return
      end
      
      @miles = meters_to_miles((params["searchmeters"].to_f) )
      @epa = Epa.find(params["model"].to_i)
      puts "meters#{(params["searchmeters"].to_f)}"
      puts "miles#{@miles}"
      puts "epa#{@epa.inspect}"
      
      gas_stations = GasZip.find_near_lat_long(params[:searchlat],params[:searchlong])
      puts gas_stations

      @avg_gas_price = gas_stations.first.avg_price rescue 0
      @start = params["from"]
      @end = params["to"]
      
      
      

      @fuel_eco = @epa.comb_mpg
      @cost = @avg_gas_price * (@miles / @fuel_eco)
      @time = to_minutes(params["searchtime"].to_f) #in seconds
      render :partial => "search"
   end
   

   def index 
   end

   def update_mfr
     models_tmp = Epa.find(:all, :conditions =>{ :year => params["year"]})
     @models= []
     models_tmp.each do |m|
       @models.push m.mfr
     end 
     @models.uniq!
     @models.sort!
     
     render :partial => "mfr"
   end
   
   def update_manu
     @models = Epa.find(:all, :conditions =>{ :mfr => params["mfr"], :year => params["year"]})

     render :partial => "makes"
   end

    private 
      def meters_to_miles(meters)
        return meters * 0.000621371192
      end
      
      def to_minutes(seconds)

      h = 99
        puts "seconds #{seconds}"
       m = (seconds/60).floor
       puts "m #{m}"
       s = (seconds - (m * 60)).round
       puts "s #{s}"

       # add leading zero to one-digit minute
       if m < 10
        m = "0#{m}"
       end
       # add leading zero to one-digit second
       if s < 10
        s = "0#{s}"
        end
       # return formatted time
       return "#{h}:#{m}"
      end
end
