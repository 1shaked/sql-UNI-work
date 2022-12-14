# This first with get the actor name and get the count of the amount of movies
# This with statment will return us a temperarey table that will allow us the return actorId, filmCount, firstName, lastName
# The process is to create a temp table that will count the amount of movies each avtor played in
# using this table to create the scaler value and with that two pieceses 
# we will select all the actors that played more then 10 of the movies count
WITH actorsFilmPlayed (actorId, filmCount, firstName, lastName)  as  (
	# for each actor return the amount of movies he play in it 
	SELECT 
		F.actor_id
		,COUNT(F.film_id) as filmCount
		,A.first_name
        ,A.last_name
	FROM 
		sakila.film_actor as F
	JOIN sakila.actor as A ON
		A.actor_id = F.actor_id
	GROUP BY 
		F.actor_id
),
# get the avg of the film palyed by an actor
AVGPlayed ( avgFilm ) as (
	# this with created only to make the code more elegent and fun to read 
    # this with will return a signle value (scalar) of the average count of movies played
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
	