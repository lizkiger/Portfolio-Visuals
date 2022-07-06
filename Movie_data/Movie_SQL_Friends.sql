
 

--SELECT Genre, Film, Budget_million, Audience_Ratings,
--CASE WHEN Genre='Action' AND Budget_million>=100 OR Genre='Adventure' AND Budget_million>=100 OR Genre='Comedy' AND Audience_Ratings>=60 OR Genre='Drama' AND Year_of_release='2011' OR Genre='Romance' AND Year_of_release='2011' OR Genre='Horror' AND Budget_million<=20 OR Genre='Thriller' AND Budget_million<=20 THEN 'Dan_approved' 
--END AS Dan_Yes
--  FROM [Lizdata].[dbo].[Movie Ratings]
--  order by Dan_Yes desc


SELECT Genre, Film, Budget_million, Audience_Ratings,
(CASE WHEN Genre='Action' AND Budget_million>=100 OR Genre='Adventure' AND Budget_million>=100 OR Genre='Comedy' AND Audience_Ratings>=60 OR Genre='Drama' AND Year_of_release='2011' OR Genre='Romance' AND Year_of_release='2011' OR Genre='Horror' AND Budget_million<=20 OR Genre='Thriller' AND Budget_million<=20 THEN 'Dan_approved' 
END) AS Dan_Yes,
(CASE WHEN Genre='Action' AND Budget_million>=11 then 'Skyler_approved' END) AS Skyler_Yes
  FROM [Lizdata].[dbo].[Movie Ratings]


