ActiveRecord::Schema.define do

   create_table :epas do |t|
     t.string   :klass
     t.string   :mfr
     t.string   :car_line
     t.string   :displacement
     t.string   :cylnder
     t.string    :transmission
     t.string    :drive_sys
     t.integer   :city_mpg
     t.integer   :hwy_mpg
     t.integer  :comb_mpg
     t.string   :fuel_type
     t.string   :year
     t.timestamps
   end
 
end