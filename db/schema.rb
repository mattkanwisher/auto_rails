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
 
  create_table :zip_codes do |t|
    t.string    :long
    t.string    :lat
    t.string    :city
    t.string    :state
    t.string    :county
    t.float    :avg_price
  end

  create_table :gas_zips do |t|
    t.string    :parent_zip
    t.string    :long
    t.string    :lat
    t.string    :in_page_id
    t.string    :gas_mini_name
    t.string    :address1
    t.string    :address2    
  end
end