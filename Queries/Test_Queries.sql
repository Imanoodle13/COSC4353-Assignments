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

SELECT * FROM VOLUNTEER;

SELECT NOW();

-- http://localhost:8080/databaseConnectionTest
SELECT 
	E.name,
	V.Username AS Moderated,
	ST_AsText(E.location) AS location,
	E.description,
	to_char(E.date, 'YYYY-MM-DD HH24:MI:SS') AS date
FROM 
	EVENT AS E
LEFT JOIN
	VOLUNTEER AS V
ON
	E.moderator = V.id;