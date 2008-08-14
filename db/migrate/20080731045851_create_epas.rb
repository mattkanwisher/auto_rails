class CreateEpas < ActiveRecord::Migration
  def self.up
    create_table :epas do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :epas
  end
end
