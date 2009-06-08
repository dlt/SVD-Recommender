class Movie < ActiveRecord::Base
  has_many :ratings
end
