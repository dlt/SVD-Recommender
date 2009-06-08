class CreateRecommendations < ActiveRecord::Migration
  def self.up
    create_table :recommendations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendations
  end
end
