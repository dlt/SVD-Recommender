require 'linalg'
class User < ActiveRecord::Base
  has_many :ratings
  has_many :recommendations

  def has_rated?(movie_id)
    rated_movie_ids.include?(movie_id) && !rate_for(movie_id).zero?
  end

  def rate_for(movie_id)
    Rating.find_by_user_id_and_movie_id(self.id, movie_id).score
  end

  def rated_movie_ids
    ratings.reject {|r| r.score.zero?}.map {|r| r.movie_id }
  end
  
  def recommendation_matrix
    matrix = Movie.all.map{|m| m.id}.map do |movie_id|
        if self.has_rated?(movie_id)
          self.rate_for(movie_id)
        else
          0
        end
      end
    Linalg::DMatrix[matrix]
  end
end
