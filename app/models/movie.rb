class Movie < ActiveRecord::Base
  enum all_ratings: ['G','PG','PG-13','R']
    
  def self.with_ratings(array)
    if array != nil && !array.empty?
      Movie.where({rating: array})
    else
      Movie.all
    end
  end
end