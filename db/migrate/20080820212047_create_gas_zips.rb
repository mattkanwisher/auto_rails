class CreateGasZips < ActiveRecord::Migration
  def self.up
    create_table :gas_zips do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :gas_zips
  end
end
