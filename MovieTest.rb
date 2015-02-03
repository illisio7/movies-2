class MovieTest
	attr_accessor :results

	def initialize 
		@results = Array.new

	end

	def push_results(user,movie,rating,prediction)

		@results.push([user,movie,rating,prediction])

	end	
	

	#counting the mean error aka average error 
	def mean
		sum = 0
		@results.each do |el|
			sum += el[2]-el[3]
		end
	return sum/@results.length

	end
	#counting the std deviation of the errors
	def stddev
		sum = 0
		mean_error = mean 
		@results.each do |el|
			sum += (el[2]-el[3]-mean_error)**2
		end
	return Math.sqrt(sum/@results.length)
	
	end

	def rms 
		sum = 0
		@results.each do |el|
			sum+=(el[2]-el[3])**2
		end
	return Math.sqrt(sum/@results.length)

	end 
end
