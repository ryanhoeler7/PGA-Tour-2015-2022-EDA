/*Determine number of wins for each player on tour since the 2015 season*/

SELECT 
	player,
	count(*) as Wins
FROM golf_data
WHERE pos = 1
GROUP BY player
ORDER BY Wins DESC;

/*Players with most majors wins*/

SELECT
	player,
	count(*) as Major_Wins
from golf_data
Where
	tournament_name IN ('The Open', 'Masters Tournament', 'U.S. Open', 'PGA Championship')
	AND pos = 1
group by 1
order by 2 DESC;

/*Player Made Cut Percentage*/

with num_tournaments as (
	SELECT
		player,
		count(*) as num_tournaments
	from golf_data
	group by 1
), made_cuts as (
	SELECT
		player,
		count(*) as made_cuts
	from golf_data
	where made_cut = 1
	group by 1
)
SELECT
	n.player,
	Coalesce(m.made_cuts,0) as made_cuts,
	n.num_tournaments,
	(Coalesce(m.made_cuts,0))/(n.num_tournaments)*100 as Made_cut_percentage
FROM num_tournaments n
Left Join made_cuts m
ON n.player = m.player
WHERE n.num_tournaments > 25
Order by 4 DESC;


/*Player Win Percentage*/

with num_tournaments as (
	SELECT
		player,
		count(*) as num_tournaments
	from golf_data
	group by 1
), wins as (
	SELECT
		player,
		count(*) as wins
	from golf_data
	where pos = 1
	group by 1
)
SELECT
	n.player,
	Coalesce(w.wins,0) as wins,
	n.num_tournaments,
	(Coalesce(w.wins,0))/(n.num_tournaments)*100 as Win_percentage
FROM num_tournaments n
Left Join wins w
ON n.player = w.player
WHERE n.num_tournaments > 25
Order by 4 DESC;

/*Rory McIlroy Wins Each Season*/

SELECT
	player,
	count(*) as wins,
	YEAR(datestamp) as 'year'
FROM golf_data
WHERE pos = 1 
AND player LIKE '%Mcilroy%'
GROUP BY YEAR(datestamp)
order by 'year' DESC;

/*Most Rounds Played*/

SELECT
	player,
	sum(n_rounds) total_rounds
FROM golf_data
group by player
order by total_rounds DESC;

/*Most Wins in Florida*/

SELECT
	Player,
	count(*) as FL_Wins
from golf_data
WHERE pos = 1
AND course like '%FL'
group by player
Order by FL_wins DESC;

/*States with Most Golf Tournaments*/

SELECT
	State_id,
	count(State_ID) total_tournaments
FROM (
	SELECT
		DISTINCT course,
		Right(course,2) as State_ID
	FROM golf_data) as tourney_state
group by state_id
order by total_tournaments DESC;

/*Player Wins by Season*/

SELECT
	player,
	YEAR(datestamp) as 'year',
	count(*) as wins
FROM golf_data
WHERE pos = 1 
group by YEAR(datestamp), player
order by 'year' DESC;	

/*Stats*/

SELECT
	player,
	avg(sg_total) total,
	avg(sg_t2g) as tee2green,
	avg(sg_putt) as putting,
	avg(sg_app) approach,
	avg(sg_arg) around_green,
	avg(sg_ott) off_tee
FROM golf_data
group by player
order by total DESC