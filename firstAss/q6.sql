# This first with get the actor name and get the count of the amount of movies
WITH actorsFilmPlayed (actorId, filmCount, firstName, lastName)  as  (
	SELECT 
		F.actor_id
		,COUNT(F.film_id) as filmCount
		,A.first_name
        ,A.last_name
		# ,AVG(COUNT(F.film_id) as A
	FROM 
		sakila.film_actor as F
	JOIN sakila.actor as A ON
		A.actor_id = F.actor_id
	GROUP BY 
		F.actor_id
),
# get the avg of the film palyed by an actor
AVGPlayed ( avgFilm ) as (
	SELECT 
		AVG(FC.filmCount) as AvgFilmCount
	FROM 
		actorsFilmPlayed as FC
)
# The query that join the two woth statments 
# by taking the actorsFilmPlayed and join with only the 
# values where the avg + 10 is <= film count
SELECT 
	A.actorId
    ,A.filmCount
    ,CONCAT(A.firstName, ' ', A.lastName) as FullName
FROM 
	actorsFilmPlayed as A
JOIN AVGPlayed as P ON
	P.avgFilm + 10 <= A.filmCount
ORDER BY 
	A.firstName ASC
    ,A.lastName ASC
	