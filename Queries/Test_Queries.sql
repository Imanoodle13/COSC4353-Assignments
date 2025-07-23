SELECT username,password FROM VOLUNTEER
	WHERE
		username = 'sarahj' AND
		password = crypt('password123',password);
-- $2a$06$jjp0bZF7iRq8kSxQ8qt7iOjJxdJOGucsvedYbI8XYE0vDwMChhBSe

SELECT 
    Username,
    (Password = '$2a$06$jjp0bZF7iRq8kSxQ8qt7iOjJxdJOGucsvedYbI8XYE0vDwMChhBSe') AS password_correct
FROM VOLUNTEER 
WHERE Username = 'sarah_admin';

SELECT * FROM EVENT;

SELECT NOW();

-- http://localhost:8080/eventmatcher
SELECT 
    E.name,
    V.Username AS moderator,
    ST_AsText(E.location) AS location,
	ARRAY_AGG(DISTINCT s.skill ORDER BY s.skill) AS skills,
    E.description,
	E.priority,
    to_char(E.date, 'YYYY-MM-DD HH24:MI:SS') AS date
FROM 
    EVENT AS E
LEFT JOIN
    VOLUNTEER AS V ON E.moderator = V.id
LEFT JOIN
    TASK AS T ON T.Event_ID = E.ID
LEFT JOIN
    LATERAL unnest(T.Skill) AS s(skill) ON TRUE
GROUP BY
    E.ID, E.name, V.Username, E.location, E.description, E.date
ORDER BY
	priority;

-- Order by skill
SELECT 
    E.name,
    V.Username AS moderator,
    ST_AsText(E.location) AS location,
	ARRAY_AGG(DISTINCT s.skill ORDER BY s.skill) AS skills,
    E.description,
    to_char(E.date, 'YYYY-MM-DD HH24:MI:SS') AS date
FROM 
    EVENT AS E
LEFT JOIN
    VOLUNTEER AS V ON E.moderator = V.id
LEFT JOIN
    TASK AS T ON T.Event_ID = E.ID
LEFT JOIN
    LATERAL unnest(T.Skill) AS s(skill) ON TRUE
GROUP BY
    E.ID, E.name, V.Username, E.location, E.description, E.date
HAVING 
	'Communication' = ANY (ARRAY_AGG(DISTINCT s.skill))
ORDER BY
	E.date;