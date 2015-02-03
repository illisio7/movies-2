class User_data
	attr_accessor :movie_and_rating

	def initialize
		@movie_and_rating = Hash.new
	end

	def return_rating(movie)
		if @movie_and_rating.has_key?(movie)
			return @movie_and_rating[movie]
		else 
			return false
		end 
	end

	def return_movies
		return @movie_and_rating.keys
	end

	def store_data (movie, rating)
		@movie_and_rating.store(movie, rating)
	end
end