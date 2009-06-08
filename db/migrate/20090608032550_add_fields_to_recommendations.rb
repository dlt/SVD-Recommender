class AddFieldsToRecommendations < ActiveRecord::Migration
  def self.up
    add_column :recommendations, :recommended_by, :integer
    add_column :recommendations, :movie_id, :integer
  end

  def self.down
    remove_column :recommendations, :recommended_by
    remove_column :recommendations, :movie_id
  end
end
