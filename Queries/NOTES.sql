/* PASSWORD MANANGEMENT AND VERIFICATION: Returns boolean if correct */
-- Correct:
SELECT 
    Username,
    (Password = crypt('admin123', Password)) AS password_correct
FROM VOLUNTEER 
WHERE Username = 'sarah_admin';
-- Incorrect:
SELECT 
    Username,
    (Password = crypt('nomyn321', Password)) AS password_correct
FROM VOLUNTEER 
WHERE Username = 'sarah_admin';