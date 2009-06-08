require 'linalg'
class Recommendation < ActiveRecord::Base

  def recommendations(user_id)
    user = User.find user_id
    users = {}
    (User.all - [user]).each do |u|
      users[u.id] = u.name
    end  
    
    # Compute the SVD Decomposition
    u, s, vt = matrix_without(user).singular_value_decomposition
    vt = vt.transpose
     
    # Take the 2-rank approximation of the Matrix
    u2 = Linalg::DMatrix.join_columns [u.column(0), u.column(1)]
    v2 = Linalg::DMatrix.join_columns [vt.column(0), vt.column(1)]
    eig2 = Linalg::DMatrix.columns [s.column(0).to_a.flatten[0,2], s.column(1).to_a.flatten[0,2]]
     
    # Here comes Bob, our new user
    user_recommendation_matrix = user.recommendation_matrix
    user_embed = user_recommendation_matrix * u2 * eig2.inverse
     
    # Compute the cosine similarity between Bob and every other User in our 2-D space

    user_sim, count = {}, 1
    v2.rows.each { |x|
        user_sim[count] = (user_embed.transpose.dot(x.transpose)) / (x.norm * user_embed.norm)
        count += 1
      }
     
    # Remove all users who fall below the 0.90 cosine similarity cutoff and sort by similarity
    similar_users = user_sim.delete_if {|k,sim| sim < 0.9 }.sort {|a,b| b[1] <=> a[1] }
    similar_users.each { |u| puts "%s (ID: %d, Similarity: %0.3f)" % [users[u[0]], u[0], u[1]]  }
    
    
    most_similar_users = most_similars(similar_users) 
    add_recommendations_to_user(user, most_similar_users)     
  end
  
  private
  def init_users
    @all_users = User.all
  end

  def add_recommendations_to_user(user, most_similars)
    most_similars.each do |sim_user|
      not_seen = sim_user.rated_movie_ids - user.rated_movie_ids
      not_seen.each do |ns_movie_id|
        recommendation = Recommendation.new({
          :recommended_by => sim_user.id,
          :movie_id => ns_movie_id,
          :user_id => user_id
        })
        puts "O usuário #{sim_user.name} recomendou o filme #{Movie.find(ns_movie_id).name} para #{user.name}"
        #user.recommendations << recommendation
      end
    end
  end
  
  def most_similars(similar_users)
    most_similars = []
    similar_users.first(2).each do |user_id, similarity|
      most_similars << User.find(user_id)
    end
    most_similars
  end

  def matrix_without(user) 
    init_users
    matrix = []
    all_movie_ids.each do |movie_id|
      matrix[movie_id] = users_ratings_without_user_for(user, movie_id)
    end 
    matrix.compact! #remove indice zero da matriz, já que não existe filme com este id
    Linalg::DMatrix[*matrix]
  end


  def all_movie_ids
    Movie.all.collect {|m| m.id }
  end
  
  def users_ratings_without_user_for(user, movie_id)
    (@all_users - [user]).map do |user|
      if user.has_rated?(movie_id)
        user.rate_for(movie_id) 
      else
        0
      end
    end
  end

end
