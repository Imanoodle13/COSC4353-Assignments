SELECT username,password FROM VOLUNTEER
	WHERE
		username = 'sarahj' AND
		password = crypt('password123',password);

/* PASSWORD MANANGEMENT AND VERIFICATION: Returns boolean if correct */
-- Correct:
SELECT 
    Username,
    (Password = crypt('password123', Password)) AS password_correct
FROM VOLUNTEER 
WHERE Username = 'sarah_admin';
-- Incorrect:
SELECT 
    Username,
    (Password = crypt('nomyn321', Password)) AS password_correct
FROM VOLUNTEER 
WHERE Username = 'sarah_admin';