Artem Malyshev
# movies-2
Solution for movies-2


I use pearson correlation for my similarity metric. It is a number between 1 and -1. 1 means that the two users are perfectly correlated
-1 means they have complete opposite tastes. So based on that I ran my prediction algorithm. The algorithm finds the 
most similar person to the user we are predicting for and predicts the rating based on whatev the most similar person gave that movie, 
If his most similar person is uncorrelated with him than I assume he will give a complete opposite rating (6-rating). 

With this prediction I have more on spot guesses compared to averaging where my guesses were close but less on spot. 
So i decided to treat a close guess as a failure and started caring more about number of correct guesses. 
Disadvantages of this approach is that I will have a higher mean error and deviation, although number of correct guesses is higher.


My algorithm is pretty slow taking about 18 minutes to finish (estimated by Time.now())
