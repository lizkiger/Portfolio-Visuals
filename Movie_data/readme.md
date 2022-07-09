My name is Liz and I am a huge fan of movies.  My friends and I love to get together, make some popcorn and relax into the weekend with a cinematic adventure.  Sounds perfect right?  The only problem is actually deciding on a movie we can all agree on.  I am about to take you on a movie data adventure to find which movie meets all of our preferences.  

The database I will be using contains 562 movies from the year 2007 to 2011.  It includes the movie genre and audience and critic ratings found from [Rotton Tomatoes](https://www.rottentomatoes.com/) and the budget of each movie.  You can check out all the data I used [here](https://github.com/lizkiger/Portfolio-Visuals/blob/main/Movie_data/Movie%20Ratings.csv).

To find out a little more, I asked each of my friends what they look for in a movie.  That includes what genre they prefer or don't prefer, if they look at audience or critic ratings, or if release year is important to them.

Before we start, let's meet the crew!

Dan:  Dan loves action and adventure movies and the more explosions the better.  He thinks the bigger the budget the more action potential.  He is willing to watch comedy as long as the audience rating is higher than 60. He will watch a Drama or Romance but only if the year of release was 2011.  He will watch Horror or Thriller but only if the budget is under $20 million.  He likes the cheesy ones with a low budget best.

Skyler:  Skyler would like to watch an action or drama movie but only if the critics rating is higher than 70.  He will watch any comedy or romance movie that came out in 2007.  He usually doesn't like horror or thriller movies but he is willing to if the audience rating is higher than 80.  He will watch any adventure movie.

Liz:  I will watch any comedy or  horror movie but only if the critic rating is higher than 65.  I usually don't like to watch dramas but am willing to if it came out in 2011.  I love thriller and action movies and will watch any of them where the audience rating is higher than 60.  I will watch romance only if the bugdet is higher than 50 million.  I will watch any adventure movie that came out in 2009 or 2010.


Based on everyone's preferences including my own, I have created a filter on SQL using CASE statements.  See project [here](https://github.com/lizkiger/Portfolio-Visuals/blob/main/Movie_data/Movie_SQL_Friends_View.sql).


  
