class User_data
	attr_accessor :movie_and_rating

	def initialize
		@movie_and_rating = Hash.new
	end
	#method that returns a rating if user has seen this movie and false if he hasn't
	def return_rating(movie)
		if @movie_and_rating.has_key?(movie)
			return @movie_and_rating[movie]
		else 
			return false
		end 
	end
	#returns the movies seen by user
	def return_movies
		return @movie_and_rating.keys
	end
	#just a helper method to make it more readible
	def store_data (movie, rating)
		@movie_and_rating.store(movie, rating)
	end
end