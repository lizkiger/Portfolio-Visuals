
--used "Create View" to pull up a new table with the filtered results found

CREATE VIEW movie_pref
AS
    SELECT Genre, Film, Budget_million, Audience_Ratings, Rotten_Tomatoes_Ratings, Year_of_release,
(CASE WHEN Genre='Action' AND Budget_million>=100 OR Genre='Adventure' 
AND Budget_million>=100 OR Genre='Comedy' 
AND Audience_Ratings>=60 OR Genre='Drama' 
AND Year_of_release='2011' OR Genre='Romance' 
AND Year_of_release='2011' OR Genre='Horror' 
AND Budget_million<=20 OR Genre='Thriller' 
AND Budget_million<=20 THEN 'Dan_approved' 
END) AS Dan_Yes,
(CASE WHEN Genre='Action' AND Rotten_Tomatoes_Ratings>=70 OR Genre='Drama' 
AND Rotten_Tomatoes_Ratings>=70 OR Genre='Comedy'AND Year_of_release='2007' 
OR Genre='Romance' AND Year_of_release='2007' OR Genre='Horror' AND Audience_Ratings>=80 
OR Genre='Thriller' AND Audience_Ratings>=80 
OR Genre='Adventure' THEN 'Skyler_approved' END) AS Skyler_Yes,

(CASE WHEN Genre='Comedy' AND Rotten_Tomatoes_Ratings>=65 
OR Genre='Horror' AND Rotten_Tomatoes_Ratings>=65 OR Genre='Drama' 
AND Year_of_release='2011' OR Genre='Thriller' AND Audience_Ratings>=60 
OR Genre='Action' AND Audience_Ratings>=60 OR Genre='Romance' 
AND Budget_million>=50 OR Genre='Adventure' AND Year_of_release='2009' 
OR Genre='Adventure' AND Year_of_release='2010' THEN 'Liz_approved' END) AS Liz_Yes
  FROM [Lizdata].[dbo].[Movie Ratings]

--now we can look at each person's movie preferences and compare them
--getting rid of the null value 

SELECT*
FROM [Lizdata].[dbo].[movie_pref]
  WHERE Dan_Yes is not null AND Liz_Yes is not null AND Skyler_Yes is not null

--let's see what genre we all agreed on

SELECT Film, Genre, Liz_Yes, Skyler_Yes, Dan_Yes
  FROM [Lizdata].[dbo].[movie_pref]
  WHERE Dan_Yes is not null AND Liz_Yes is not null AND Skyler_Yes is not null
  order by Genre, Film

  --it looks like we have narrowed it down to either Action, Adventure or Drama
  --now the question is how we decide on what to watch with 35 options
  --we agreed that we would pick the movie from 2011 (the most recent year of this data) that had the highest budget

  
  SELECT Top 1 Film, Year_of_release, Budget_million, Audience_Ratings, Genre, Liz_Yes, Skyler_Yes, Dan_Yes
  FROM [Lizdata].[dbo].[movie_pref]
  WHERE Dan_Yes is not null AND Liz_Yes is not null AND Skyler_Yes is not null
  order by Year_of_release desc, Budget_million desc

  --by selecting the top 1, we have our winner!  X-Men: First Class
 
  
 
  
  