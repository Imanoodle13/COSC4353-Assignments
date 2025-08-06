-- Insert roles
INSERT INTO ROLE (Name) VALUES 
('Admin'),
('Regular');

-- Insert 20 volunteers (5 admins, 15 regulars) with multiple skills
INSERT INTO VOLUNTEER (Role_ID, First_name, Last_name, Username, Email, Password, Skill, Location, Availability)
VALUES
-- Admins (ID 1-5)
(1, 'Alice', 'Admin', 'alicea', 'alice@example.com', crypt('pass', gen_salt('bf')), ARRAY['Leadership','Coordination'], '100 Admin St, Houston, TX 77001', ARRAY['Weekdays','Evenings']),
(1, 'Bob', 'Boss', 'bobb', 'bob@example.com', crypt('pass', gen_salt('bf')), ARRAY['Organization','Management'], '101 Admin Rd, Dallas, TX 75001', ARRAY['Weekends','Mornings']),
(1, 'Carol', 'Chief', 'carolc', 'carol@example.com', crypt('pass', gen_salt('bf')), ARRAY['Public Speaking','Scheduling'], '102 Chief Dr, Austin, TX 73301', ARRAY['Weekdays','Afternoons']),
(1, 'David', 'Director', 'david_d', 'david@example.com', crypt('pass', gen_salt('bf')), ARRAY['Negotiation','Planning'], '103 Dir Ave, San Antonio, TX 78201', ARRAY['Weekends']),
(1, 'Eve', 'Exec', 'evee', 'eve@example.com', crypt('pass', gen_salt('bf')), ARRAY['Decision Making','Conflict Resolution'], '104 Exec Blvd, El Paso, TX 79901', ARRAY['Mornings','Evenings']),

-- Regular Volunteers (ID 6-20)
(2, 'Frank', 'Field', 'frankf', 'frank@example.com', crypt('pass', gen_salt('bf')), ARRAY['First Aid','Manual Labor'], '200 Field St, Lubbock, TX 79401', ARRAY['Weekdays']),
(2, 'Grace', 'Grounds', 'graceg', 'grace@example.com', crypt('pass', gen_salt('bf')), ARRAY['Photography','Social Media'], '201 Grounds Rd, Plano, TX 75074', ARRAY['Weekends']),
(2, 'Heidi', 'Helper', 'heidih', 'heidi@example.com', crypt('pass', gen_salt('bf')), ARRAY['Childcare','Teaching'], '202 Helper Ln, Irving, TX 75038', ARRAY['Mornings']),
(2, 'Ivan', 'Installer', 'ivani', 'ivan@example.com', crypt('pass', gen_salt('bf')), ARRAY['Technical Setup','Wiring'], '203 Install Dr, Garland, TX 75040', ARRAY['Afternoons']),
(2, 'Judy', 'Joiner', 'judyj', 'judy@example.com', crypt('pass', gen_salt('bf')), ARRAY['Logistics','Distribution'], '204 Joiner Ct, Amarillo, TX 79101', ARRAY['Evenings']),
(2, 'Ken', 'Keeper', 'kenk', 'ken@example.com', crypt('pass', gen_salt('bf')), ARRAY['Security','First Aid'], '205 Keeper Blvd, McKinney, TX 75069', ARRAY['Weekends']),
(2, 'Laura', 'Loader', 'laural', 'laura@example.com', crypt('pass', gen_salt('bf')), ARRAY['Lifting','Sorting'], '206 Loader Way, Frisco, TX 75034', ARRAY['Weekdays']),
(2, 'Mallory', 'Mover', 'mallorym', 'mallory@example.com', crypt('pass', gen_salt('bf')), ARRAY['Inventory','Transport'], '207 Mover Blvd, Killeen, TX 76541', ARRAY['Mornings']),
(2, 'Niaj', 'Network', 'niajn', 'niaj@example.com', crypt('pass', gen_salt('bf')), ARRAY['Networking','Coordination'], '208 Network St, Brownsville, TX 78520', ARRAY['Afternoons']),
(2, 'Olivia', 'Organizer', 'oliviao', 'olivia@example.com', crypt('pass', gen_salt('bf')), ARRAY['Setup','Planning'], '209 Organizer Rd, Pasadena, TX 77506', ARRAY['Evenings']),
(2, 'Peggy', 'Planner', 'peggyp', 'peggy@example.com', crypt('pass', gen_salt('bf')), ARRAY['Communication','Crowd Control'], '210 Planner Dr, Mesquite, TX 75149', ARRAY['Weekdays']),
(2, 'Rupert', 'Runner', 'rupertr', 'rupert@example.com', crypt('pass', gen_salt('bf')), ARRAY['Errands','Logistics'], '211 Runner Ave, McAllen, TX 78501', ARRAY['Weekends']),
(2, 'Sybil', 'Support', 'sybils', 'sybil@example.com', crypt('pass', gen_salt('bf')), ARRAY['Support','Registration'], '212 Support Blvd, Midland, TX 79701', ARRAY['Mornings']),
(2, 'Trent', 'Technician', 'trentt', 'trent@example.com', crypt('pass', gen_salt('bf')), ARRAY['Audio','Video','Lighting'], '213 Tech St, Denton, TX 76201', ARRAY['Afternoons']),
(2, 'Victor', 'Volunteer', 'victorv', 'victor@example.com', crypt('pass', gen_salt('bf')), ARRAY['Guidance','Greeting'], '214 Welcome Rd, Waco, TX 76701', ARRAY['Evenings']);

-- Insert Events (varied priorities and event counts: 5,4,3,2,1)
INSERT INTO EVENT (Name, Moderator, Location, Description, Priority, Date)
VALUES
-- 5 Events by Admin 1
('Food Drive', 1, '301 Food St, Houston, TX 77001', 'Collecting food for the needy', 3, '2025-08-10'),
('Blood Donation', 1, '302 Blood Rd, Houston, TX 77002', 'Organizing blood donors', 4, '2025-08-12'),
('Clothes Collection', 1, '303 Clothes Ave, Houston, TX 77003', 'Collecting used clothes', 2, '2025-08-14'),
('Charity Walk', 1, '304 Walk Blvd, Houston, TX 77004', 'Fundraising walk', 5, '2025-08-16'),
('Awareness Seminar', 1, '305 Seminar Dr, Houston, TX 77005', 'Community health seminar', 1, '2025-08-18'),

-- 4 Events by Admin 2
('Tree Planting', 2, '401 Green St, Dallas, TX 75201', 'Environmental awareness', 2, '2025-08-11'),
('Park Cleanup', 2, '402 Clean Ave, Dallas, TX 75202', 'Cleaning public parks', 3, '2025-08-13'),
('Homeless Outreach', 2, '403 Help Blvd, Dallas, TX 75203', 'Helping homeless', 4, '2025-08-15'),
('Art for Kids', 2, '404 Art Rd, Dallas, TX 75204', 'Creative activities for children', 5, '2025-08-17'),

-- 3 Events by Admin 3
('STEM Workshop', 3, '501 Tech Dr, Austin, TX 73301', 'Teaching STEM to kids', 1, '2025-08-10'),
('Senior Visit', 3, '502 Care St, Austin, TX 73302', 'Visiting retirement homes', 3, '2025-08-12'),
('Pet Adoption', 3, '503 Pet Ave, Austin, TX 73303', 'Pet adoption drive', 4, '2025-08-14'),

-- 2 Events by Admin 4
('Recycling Drive', 4, '601 Recycle Rd, San Antonio, TX 78201', 'Recycling awareness', 2, '2025-08-11'),
('Tech Help Day', 4, '602 Help Ln, San Antonio, TX 78202', 'Helping seniors with tech', 5, '2025-08-13'),

-- 1 Event by Admin 5
('Women Empowerment Talk', 5, '701 Empower Blvd, El Paso, TX 79901', 'Empowerment seminar', 1, '2025-08-15');

-- Insert Tasks (linked to events and with non-null skill arrays)
INSERT INTO TASK (Event_ID, Name, Skill, Description)
VALUES
(1, 'Collect Donations', ARRAY['Inventory','Logistics'], 'Gather and organize donated items'),
(2, 'Setup Booths', ARRAY['Setup','Public Speaking'], 'Set up booths and speak with donors'),
(3, 'Sort Clothes', ARRAY['Sorting','Folding'], 'Sort and fold donated clothes'),
(4, 'Route Planning', ARRAY['Navigation','Logistics'], 'Plan the charity walk route'),
(5, 'Speaker Coordination', ARRAY['Scheduling','Communication'], 'Coordinate with guest speakers'),
(6, 'Dig and Plant', ARRAY['Manual Labor','Gardening'], 'Assist in tree planting'),
(7, 'Garbage Pickup', ARRAY['Cleaning','Sorting'], 'Clean up trash from parks'),
(8, 'Meal Prep', ARRAY['Cooking','Distribution'], 'Prepare meals for homeless'),
(9, 'Art Supervision', ARRAY['Drawing','Childcare'], 'Guide kids through activities'),
(10, 'Tech Demos', ARRAY['Teaching','Computers'], 'Demo technology to kids'),
(11, 'Reading Time', ARRAY['Reading','Elderly Care'], 'Read stories to the elderly'),
(12, 'Animal Handling', ARRAY['Animal Care','Registration'], 'Assist with pet adoptions'),
(13, 'Bottle Sorting', ARRAY['Recycling','Sorting'], 'Sort bottles into bins'),
(14, 'Device Help', ARRAY['Technical Support','Patience'], 'Assist seniors with devices'),
(15, 'Speaker Support', ARRAY['AV Setup','Hospitality'], 'Help speakers at seminar');

-- Insert into VOLUNTEER_TASK (linking tasks to volunteers)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted)
VALUES
(1, 6, '2025-08-01'),
(2, 7, '2025-08-01'),
(3, 8, '2025-08-02'),
(4, 9, '2025-08-03'),
(5, 10, '2025-08-03'),
(6, 11, '2025-08-04'),
(7, 12, '2025-08-04'),
(8, 13, '2025-08-04'),
(9, 14, '2025-08-05'),
(10, 15, '2025-08-05'),
(11, 16, '2025-08-06'),
(12, 17, '2025-08-06'),
(13, 18, '2025-08-07'),
(14, 19, '2025-08-07'),
(15, 20, '2025-08-07');

-- Insert into VOLUNTEER_HIST (task logs)
INSERT INTO VOLUNTEER_HIST (V_task_ID, Start_time, End_time)
VALUES
(1, '2025-08-10 08:00:00', '2025-08-10 10:00:00'),
(2, '2025-08-10 09:00:00', '2025-08-10 11:00:00'),
(3, '2025-08-11 10:00:00', '2025-08-11 12:00:00'),
(4, '2025-08-11 11:00:00', '2025-08-11 13:00:00'),
(5, '2025-08-12 12:00:00', '2025-08-12 14:00:00'),
(6, '2025-08-12 14:00:00', '2025-08-12 16:00:00'),
(7, '2025-08-13 08:00:00', '2025-08-13 10:00:00'),
(8, '2025-08-13 09:30:00', '2025-08-13 11:00:00'),
(9, '2025-08-14 13:00:00', '2025-08-14 15:00:00'),
(10, '2025-08-14 15:00:00', '2025-08-14 17:00:00'),
(11, '2025-08-15 08:00:00', '2025-08-15 09:00:00'),
(12, '2025-08-15 09:30:00', '2025-08-15 11:30:00'),
(13, '2025-08-16 10:00:00', '2025-08-16 12:00:00'),
(14, '2025-08-16 12:00:00', '2025-08-16 14:00:00'),
(15, '2025-08-17 08:00:00', '2025-08-17 10:00:00');
