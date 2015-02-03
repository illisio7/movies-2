class MovieData
	attr_accessor :train_data, :test_data, :movTest
	#initializing and loading train and test data 
	def initialize (folder, u=nil)
		@train_data = Hash.new
		@test_data = Hash.new
		if u == nil 
			@train_file = File.open(folder + "/u.data")
		else 
			@train_file = File.open(folder+"/"+u+".base")
			@test_file = File.open(folder+"/"+u+".test")
		end

		load_data(@train_file, @train_data)
	end
	#load the data files and if k = int then the first k lines of that file
	def load_data (file, data, k=nil)
		i=0
		file.each_line do |line|
			if i ==k 
				break
			end
			words = line.split("\t")
			if data.has_key?(words[0].to_i)
				data[words[0].to_i].store_data(words[1].to_i,words[2].to_i)
			else
				x = User_data.new
				x.store_data(words[1].to_i,words[2].to_i)
				data.store(words[0].to_i, x)
			end
			i+=1
		end
	end

	#returns rating of the movie the user has given
	def rating (user, movie)
		if @train_data.has_key?(user) && @train_data[user].return_rating(movie)
			return @train_data[user].return_rating(movie)
		else
			return 0
		end
	end
	#returns array of movies the user has watched
	def movies(user)
		if @train_data.has_key?(user)
			return @train_data[user].return_movies
		else
			return 0
		end
	end
	#returns and array of users who seen this movies
	def viewers (movie)
		view = Array.new
		@train_data.each_value do |val| 
			if val.return_rating(movie)
				view.push(@train_data.key(val))
			end
		end
		return view
	end		

	def sort_decrease_order (hash)
		return hash.sort_by(&:last).reverse
	end

	
	#using pearson correlation for similarity, 1 = perfect corelation -1 = opposite correlation
	def pearson_similarity (u1,u2)
		similarity = @train_data[u1].movie_and_rating.keys & @train_data[u2].movie_and_rating.keys
		if similarity.empty?
			return 0
		end
		sum_1 = 0
		sum_2 = 0
		sum_1_sq = 0
		sum_2_sq = 0
		product = 0

		similarity.each do |mov|
			sum_1 += @train_data[u1].return_rating(mov)
			sum_1_sq += @train_data[u1].return_rating(mov)**2
			sum_2 += @train_data[u2].return_rating(mov)
			sum_2_sq += @train_data[u2].return_rating(mov)**2
			product += @train_data[u1].return_rating(mov)*@train_data[u2].return_rating(mov)
		end

		numerator = product - (sum_1*sum_2/similarity.length)
		denom = Math.sqrt((sum_1_sq-(sum_1**2)/similarity.length)*(sum_2_sq-(sum_2**2)/similarity.length))

		if denom == 0 
			return 0
		end
		return numerator/denom
	end

	
	

	#returns similarities of all users in respect to u1, sorted
	def most_similar (u1)
		hash_user_similar = Hash.new
		@train_data.each_key do |d|
			hash_user_similar.store(d, pearson_similarity(u1,d))
		end
		hash_user_similar.delete(u1)
		return sort_decrease_order(hash_user_similar)

	end
	#predict what user u will give movie m by assumin he will give the same rating as the user who is most similar to him and who has seen the movie. 
	#if most similar is <0 then assume he will give the complete opposite rating of that user
	def predict (u, m)
		users = most_similar(u)

		users.each do |el|
			if @train_data[el[0]].return_rating(m)
				if el[1] >= 0 
					return @train_data[el[0]].return_rating(m)
				else  return 6-@train_data[el[0]].return_rating(m)
				end
			end
		end
	end

	#run the tests on the specified number of lines, if not specified run on the whole set
	def run_test(lines=nil)
		@movTest = MovieTest.new
		load_data(@test_file, @test_data, lines)

		@test_data.each_key do |k|
			@test_data[k].movie_and_rating.each_key do |key|
				movTest.push_results(k,key,@test_data[k].movie_and_rating[key],predict(k, @test_data[k].movie_and_rating[key]))
			end
		end
	end
	
end

require "./user_data"
require "./MovieTest"
m = MovieData.new("ml-100k","u1")


puts Time.now
  m.run_test
p  m.movTest.results

puts Time.now


puts "Mean = "
puts m.movTest.mean
puts "StdDev = "
puts m.movTest.stddev
puts "RMS ="
puts m.movTest.rms


 # puts m.test_data

#p m.viewers(1)
