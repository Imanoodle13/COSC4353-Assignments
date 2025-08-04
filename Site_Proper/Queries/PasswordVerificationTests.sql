-- SAMPLE:
--     username:         'jlong'
--     entered_password: 'vol567'

-- Returns ID of the user if correct.
SELECT id FROM VOLUNTEER
WHERE
  Username = 'jlong'
  AND Password = crypt('vol567', Password);

-- Returns a boolean if the entered password is correct.
SELECT (Password = crypt('vol567', Password)) AS ok
FROM VOLUNTEER
WHERE Username = 'jlong';