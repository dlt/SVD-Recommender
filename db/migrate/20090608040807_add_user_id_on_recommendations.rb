class AddUserIdOnRecommendations < ActiveRecord::Migration
  def self.up
    add_column :recommendations, :user_id, :integer
  end

  def self.down
    remove_column :recommendations, :user_id
  end
end
