class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  validates_numericality_of :score, :only_integer => true, :message => "A nota deve ser um número"
  validates_inclusion_of :score, :in => 0..5, :message => "deve ser no mínimo 0 e no máximo 5." 
end
