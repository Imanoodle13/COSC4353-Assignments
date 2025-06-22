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