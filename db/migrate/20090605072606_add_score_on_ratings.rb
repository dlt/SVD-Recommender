class AddScoreOnRatings < ActiveRecord::Migration
  def self.up
    add_column :ratings, :score, :integer
  end

  def self.down
    remove_column :ratings, :score
  end
end
