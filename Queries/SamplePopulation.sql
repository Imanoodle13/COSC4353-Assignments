INSERT INTO ROLE (Name) VALUES 
('Admin'),
('Volunteer');

-- 5 Admins
INSERT INTO VOLUNTEER (Role_ID, First_name, Last_name, Username, Email, Password, Skill, Location, Availability)
VALUES 
(1, 'Alice',   'Nguyen', 'alice_ng', 'alice@example.com', crypt('alice123', gen_salt('bf')), ARRAY['Leadership'], ST_GeogFromText('SRID=4326;POINT(-95.3698 29.7604)'), ARRAY['Mon', 'Wed']),
(1, 'Bob',     'Smith',  'bob_s',    'bob@example.com',   crypt('bob123', gen_salt('bf')),   ARRAY['Planning'],   ST_GeogFromText('SRID=4326;POINT(-95.3633 29.7633)'), ARRAY['Tue']),
(1, 'Carla',   'Jones',  'cjones',   'carla@example.com', crypt('carla123', gen_salt('bf')), ARRAY['Finance'],    ST_GeogFromText('SRID=4326;POINT(-95.3910 29.7370)'), ARRAY['Fri']),
(1, 'David',   'Lee',    'dlee',     'david@example.com', crypt('david123', gen_salt('bf')), ARRAY['Tech'],       ST_GeogFromText('SRID=4326;POINT(-95.3332 29.7842)'), ARRAY['Mon', 'Thu']),
(1, 'Ella',    'White',  'ewhite',   'ella@example.com',  crypt('ella123', gen_salt('bf')),  ARRAY['Logistics'],  ST_GeogFromText('SRID=4326;POINT(-95.3640 29.7690)'), ARRAY['Sun']);

-- 15 Regular Volunteers
INSERT INTO VOLUNTEER (Role_ID, First_name, Last_name, Username, Email, Password, Skill, Location, Availability)
VALUES
(2, 'Frank',   'Taylor',   'ftaylor',  'frank@example.com',  crypt('frank123', gen_salt('bf')), ARRAY['Logistics'],  ST_GeogFromText('SRID=4326;POINT(-95.3621 29.7522)'), ARRAY['Sat', 'Sun']),
(2, 'Grace',   'Morris',   'gmorris',  'grace@example.com',  crypt('grace123', gen_salt('bf')), ARRAY['Medical'],     ST_GeogFromText('SRID=4326;POINT(-95.3901 29.7410)'), ARRAY['Fri']),
(2, 'Henry',   'Clark',    'hclark',   'henry@example.com',  crypt('henry123', gen_salt('bf')), ARRAY['First Aid'],   ST_GeogFromText('SRID=4326;POINT(-95.3500 29.7500)'), ARRAY['Thu']),
(2, 'Isla',    'Diaz',     'idiaz',    'isla@example.com',   crypt('isla123', gen_salt('bf')),  ARRAY['Cooking'],     ST_GeogFromText('SRID=4326;POINT(-95.3700 29.7800)'), ARRAY['Wed']),
(2, 'Jack',    'Evans',    'jevans',   'jack@example.com',   crypt('jack123', gen_salt('bf')),  ARRAY['Driving'],     ST_GeogFromText('SRID=4326;POINT(-95.3300 29.7600)'), ARRAY['Tue']),
(2, 'Kara',    'Flores',   'kflores',  'kara@example.com',   crypt('kara123', gen_salt('bf')),  ARRAY['Setup'],       ST_GeogFromText('SRID=4326;POINT(-95.3690 29.7550)'), ARRAY['Mon']),
(2, 'Leo',     'Gomez',    'lgomez',   'leo@example.com',    crypt('leo123', gen_salt('bf')),   ARRAY['Security'],    ST_GeogFromText('SRID=4326;POINT(-95.3650 29.7580)'), ARRAY['Sun']),
(2, 'Mia',     'Hall',     'mhall',    'mia@example.com',    crypt('mia123', gen_salt('bf')),   ARRAY['Medical'],     ST_GeogFromText('SRID=4326;POINT(-95.3580 29.7490)'), ARRAY['Mon']),
(2, 'Noah',    'Ibrahim',  'nibrahim', 'noah@example.com',   crypt('noah123', gen_salt('bf')),  ARRAY['Rescue'],      ST_GeogFromText('SRID=4326;POINT(-95.3900 29.7700)'), ARRAY['Tue']),
(2, 'Olivia',  'Jackson',  'ojackson', 'olivia@example.com', crypt('olivia123', gen_salt('bf')),ARRAY['Teaching'],    ST_GeogFromText('SRID=4326;POINT(-95.3770 29.7400)'), ARRAY['Thu']),
(2, 'Paul',    'Kim',      'pkim',     'paul@example.com',   crypt('paul123', gen_salt('bf')),  ARRAY['Tech'],        ST_GeogFromText('SRID=4326;POINT(-95.3440 29.7470)'), ARRAY['Sat']),
(2, 'Quinn',   'Lopez',    'qlopez',   'quinn@example.com',  crypt('quinn123', gen_salt('bf')), ARRAY['First Aid'],   ST_GeogFromText('SRID=4326;POINT(-95.3550 29.7650)'), ARRAY['Fri']),
(2, 'Ruby',    'Martin',   'rmartin',  'ruby@example.com',   crypt('ruby123', gen_salt('bf')),  ARRAY['Logistics'],   ST_GeogFromText('SRID=4326;POINT(-95.3590 29.7590)'), ARRAY['Tue']),
(2, 'Sam',     'Nguyen',   'snguyen',  'sam@example.com',    crypt('sam123', gen_salt('bf')),   ARRAY['Medical'],     ST_GeogFromText('SRID=4326;POINT(-95.3390 29.7450)'), ARRAY['Wed']),
(2, 'Tina',    'Ortiz',    'tortiz',   'tina@example.com',   crypt('tina123', gen_salt('bf')),  ARRAY['Security'],    ST_GeogFromText('SRID=4326;POINT(-95.3705 29.7655)'), ARRAY['Mon', 'Wed']);

-- Admin: Alice -> 3 Events
INSERT INTO EVENT (Name, Moderator, Location, Description, Priority, Date) VALUES
('Community Clean-up', 1, ST_GeogFromText('SRID=4326;POINT(-95.3598 29.7620)'), 'Clean up the local park', 2, '2025-08-05 09:00'),
('Food Drive',         1, ST_GeogFromText('SRID=4326;POINT(-95.3652 29.7635)'), 'Distribute food to families', 3, '2025-08-12 10:00'),
('Blood Donation',     1, ST_GeogFromText('SRID=4326;POINT(-95.3684 29.7504)'), 'Organize blood donors and stations', 4, '2025-08-18 08:00');

-- Admin: Bob -> 2 Events
INSERT INTO EVENT (Name, Moderator, Location, Description, Priority, Date) VALUES
('Tree Planting',      2, ST_GeogFromText('SRID=4326;POINT(-95.3702 29.7699)'), 'Plant trees near schools', 2, '2025-08-10 09:00'),
('Tech Literacy Day',  2, ST_GeogFromText('SRID=4326;POINT(-95.3644 29.7602)'), 'Teach tech to seniors', 1, '2025-08-15 13:00');

-- Admin: Carla -> 1 Event
INSERT INTO EVENT (Name, Moderator, Location, Description, Priority, Date) VALUES
('Emergency Prep Workshop', 3, ST_GeogFromText('SRID=4326;POINT(-95.3688 29.7658)'), 'Emergency procedures and kits', 5, '2025-08-20 11:00');

-- Admin: David -> 0 Events
-- Admin: Ella -> 0 Events

-- Tasks for 'Community Clean-up'
INSERT INTO TASK (Event_ID, Skill, Description) VALUES
(1, ARRAY['Logistics'], 'Set up waste bins and organize teams'),
(1, ARRAY['Driving'],   'Drive collected waste to depot'),
(1, ARRAY['First Aid'], 'Monitor volunteer health during cleanup');

-- Tasks for 'Food Drive'
INSERT INTO TASK (Event_ID, Skill, Description) VALUES
(2, ARRAY['Logistics'], 'Organize canned goods by category'),
(2, ARRAY['Driving'],   'Deliver food packages to assigned areas');

-- Tasks for 'Blood Donation'
INSERT INTO TASK (Event_ID, Skill, Description) VALUES
(3, ARRAY['Medical'],   'Assist donors during blood draw'),
(3, ARRAY['Tech'],      'Register participants digitally');

-- Tasks for 'Tree Planting'
INSERT INTO TASK (Event_ID, Skill, Description) VALUES
(4, ARRAY['Rescue'],    'Clear planting space'),
(4, ARRAY['Teaching'],  'Teach students proper planting techniques');

-- Tasks for 'Tech Literacy Day'
INSERT INTO TASK (Event_ID, Skill, Description) VALUES
(5, ARRAY['Tech'],      'Guide seniors on basic smartphone use'),
(5, ARRAY['Teaching'],  'Present simple tutorials');

-- Tasks for 'Emergency Prep Workshop'
INSERT INTO TASK (Event_ID, Skill, Description) VALUES
(6, ARRAY['Logistics'], 'Set up booths and materials'),
(6, ARRAY['Medical'],   'Explain first aid procedures');

-- Get Volunteer IDs manually if needed (e.g., SELECT ID, Username FROM VOLUNTEER;)
-- Assume IDs 6-20 are non-admin volunteers

-- Assignments for Task 1 (Set up waste bins...)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(1, 6, '2025-07-15'),
(1, 7, '2025-07-15');

-- Task 2 (Drive collected waste...)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(2, 8, '2025-07-15'),
(2, 9, '2025-07-15');

-- Task 3 (Monitor health)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(3, 10, '2025-07-15'),
(3, 11, '2025-07-15');

-- Task 4 (Organize canned goods)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(4, 12, '2025-07-16'),
(4, 13, '2025-07-16');

-- Task 5 (Deliver food)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(5, 14, '2025-07-16'),
(5, 15, '2025-07-16');

-- Task 6 (Assist donors)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(6, 16, '2025-07-17'),
(6, 17, '2025-07-17');

-- Task 7 (Register participants)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(7, 18, '2025-07-17'),
(7, 19, '2025-07-17');

-- Task 8 (Clear planting space)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(8, 20, '2025-07-18'),
(8, 6,  '2025-07-18');

-- Task 9 (Teach planting)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(9, 7,  '2025-07-18'),
(9, 8,  '2025-07-18');

-- Task 10 (Teach smartphone use)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(10, 9,  '2025-07-18'),
(10, 10, '2025-07-18');

-- Task 11 (Present tutorials)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(11, 11, '2025-07-18'),
(11, 12, '2025-07-18');

-- Task 12 (Set up booths)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(12, 13, '2025-07-19'),
(12, 14, '2025-07-19');

-- Task 13 (Explain first aid)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(13, 15, '2025-07-19'),
(13, 16, '2025-07-19');

-- Add history for task 1 (Volunteer 6)
INSERT INTO VOLUNTEER_HIST (V_task_ID, Start_time, End_time) VALUES
(1, '2025-08-05 08:45', '2025-08-05 11:00'),
(2, '2025-08-05 08:50', '2025-08-05 11:00');

-- Task 2
INSERT INTO VOLUNTEER_HIST (V_task_ID, Start_time, End_time) VALUES
(3, '2025-08-05 11:10', '2025-08-05 12:30'),
(4, '2025-08-05 11:15', '2025-08-05 12:45');

-- Task 4
INSERT INTO VOLUNTEER_HIST (V_task_ID, Start_time, End_time) VALUES
(7, '2025-08-12 09:00', '2025-08-12 12:00'),
(8, '2025-08-12 09:05', '2025-08-12 12:10');