-- Sample Data Population for Volunteer Management Database
-- Clear existing data (if any)
TRUNCATE TABLE VOLUNTEER_HIST CASCADE;
TRUNCATE TABLE VOLUNTEER_TASK CASCADE;
TRUNCATE TABLE TASK CASCADE;
TRUNCATE TABLE EVENT CASCADE;
TRUNCATE TABLE VOLUNTEER CASCADE;
TRUNCATE TABLE ROLE CASCADE;

-- Reset sequences
ALTER SEQUENCE role_id_seq RESTART WITH 1;
ALTER SEQUENCE volunteer_id_seq RESTART WITH 1;
ALTER SEQUENCE event_id_seq RESTART WITH 1;
ALTER SEQUENCE task_id_seq RESTART WITH 1;
ALTER SEQUENCE volunteer_task_id_seq RESTART WITH 1;
ALTER SEQUENCE volunteer_hist_id_seq RESTART WITH 1;

-- Populate ROLE table
INSERT INTO ROLE (Name) VALUES 
('Admin'),
('Regular');

-- Populate VOLUNTEER table
INSERT INTO VOLUNTEER (Role_ID, First_name, Last_name, Username, Email, Password, Skill, Location, Availability, Date_enrolled) VALUES
-- Admins (ID 1-5)
(1, 'Alice', 'Johnson', 'alicej', 'alice@example.com', crypt('PassAlice1', gen_salt('bf')), ARRAY['First Aid', 'Teamwork'], '12345 Main St, Houston, TX 77001', ARRAY['Monday', 'Wednesday', 'Friday'], '2024-01-10'),
(1, 'Bob', 'Smith', 'bobsmith', 'bob@example.com', crypt('PassBob2', gen_salt('bf')), ARRAY['Coordination'], '23456 Oak Ave, Houston, TX 77002', ARRAY['Tuesday', 'Thursday'], '2024-02-12'),
(1, 'Clara', 'Lopez', 'claralo', 'clara@example.com', crypt('PassClara3', gen_salt('bf')), ARRAY['Logistics', 'Scheduling'], '34567 Pine Rd, Houston, TX 77003', ARRAY['Monday', 'Tuesday', 'Friday'], '2024-03-15'),
(1, 'David', 'Nguyen', 'davidn', 'david@example.com', crypt('PassDavid4', gen_salt('bf')), ARRAY['Communication', 'Driving', 'Cleaning'], '45678 Cedar Ln, Houston, TX 77004', ARRAY['Wednesday', 'Saturday'], '2024-04-18'),
(1, 'Eva', 'Patel', 'evap', 'eva@example.com', crypt('PassEva5', gen_salt('bf')), ARRAY['Event Planning'], '56789 Birch Blvd, Houston, TX 77005', ARRAY['Sunday'], '2024-05-20'),

-- Regular Volunteers (ID 6–20)
(2, 'Frank', 'Wright', 'frankw', 'frank@example.com', crypt('PassFrank6', gen_salt('bf')), ARRAY['Tech Support'], '67890 Elm St, Houston, TX 77006', ARRAY['Monday'], '2024-01-11'),
(2, 'Grace', 'Lee', 'gracelee', 'grace@example.com', crypt('PassGrace7', gen_salt('bf')), ARRAY['Translation', 'Cleaning'], '78901 Ash Ct, Houston, TX 77007', ARRAY['Tuesday', 'Thursday'], '2024-01-12'),
(2, 'Henry', 'Khan', 'henryk', 'henry@example.com', crypt('PassHenry8', gen_salt('bf')), ARRAY['Driving', 'Scheduling'], '89012 Maple Dr, Houston, TX 77008', ARRAY['Friday'], '2024-01-13'),
(2, 'Ivy', 'Kim', 'ivyk', 'ivy@example.com', crypt('PassIvy9', gen_salt('bf')), ARRAY['Communication'], '90123 Walnut Pl, Houston, TX 77009', ARRAY['Wednesday', 'Saturday'], '2024-01-14'),
(2, 'Jake', 'Owen', 'jakeo', 'jake@example.com', crypt('PassJake10', gen_salt('bf')), ARRAY['Event Planning', 'Teamwork'], '13579 Spruce Way, Houston, TX 77010', ARRAY['Sunday'], '2024-01-15'),
(2, 'Karen', 'Choi', 'kchoi', 'karen@example.com', crypt('PassKaren11', gen_salt('bf')), ARRAY['Tech Support', 'First Aid'], '24680 Fir Ln, Houston, TX 77011', ARRAY['Monday', 'Tuesday'], '2024-01-16'),
(2, 'Leo', 'Martinez', 'leom', 'leo@example.com', crypt('PassLeo12', gen_salt('bf')), ARRAY['Coordination', 'Logistics'], '35791 Cypress St, Houston, TX 77012', ARRAY['Thursday', 'Saturday'], '2024-01-17'),
(2, 'Mia', 'Turner', 'miat', 'mia@example.com', crypt('PassMia13', gen_salt('bf')), ARRAY['Driving'], '46802 Sycamore Rd, Houston, TX 77013', ARRAY['Friday'], '2024-01-18'),
(2, 'Nate', 'Ali', 'natea', 'nate@example.com', crypt('PassNate14', gen_salt('bf')), ARRAY['Scheduling'], '57913 Beech Blvd, Houston, TX 77014', ARRAY['Wednesday'], '2024-01-19'),
(2, 'Olivia', 'Park', 'oliviap', 'olivia@example.com', crypt('PassOlivia15', gen_salt('bf')), ARRAY['Translation', 'Communication'], '68024 Dogwood Ave, Houston, TX 77015', ARRAY['Sunday'], '2024-01-20'),
(2, 'Paul', 'Rodriguez', 'paulr', 'paul@example.com', crypt('PassPaul16', gen_salt('bf')), ARRAY['Cleaning'], '79135 Hemlock Dr, Houston, TX 77016', ARRAY['Monday', 'Thursday'], '2024-01-21'),
(2, 'Queenie', 'Singh', 'queens', 'queenie@example.com', crypt('PassQueenie17', gen_salt('bf')), ARRAY['Event Planning', 'First Aid'], '80246 Larch Ct, Houston, TX 77017', ARRAY['Friday', 'Saturday'], '2024-01-22'),
(2, 'Ray', 'Diaz', 'rayd', 'ray@example.com', crypt('PassRay18', gen_salt('bf')), ARRAY['Coordination', 'Tech Support'], '91357 Alder Blvd, Houston, TX 77018', ARRAY['Tuesday'], '2024-01-23'),
(2, 'Sara', 'Baker', 'sarab', 'sara@example.com', crypt('PassSara19', gen_salt('bf')), ARRAY['Logistics'], '10246 Poplar Ln, Houston, TX 77019', ARRAY['Monday', 'Sunday'], '2024-01-24');

-- Populate EVENT table (Admin IDs: 1-5)
-- Admin 1: 4 events
INSERT INTO EVENT (Name, Moderator, Location, Description, Priority, Date, Date_published) VALUES
('Health Fair', 1, '11111 Wellness Rd, Houston, TX 77020', 'Community health awareness event.', 5, '2025-08-10 10:00', '2025-08-01 12:00'),
('Disaster Drill', 1, '22222 Safety Blvd, Houston, TX 77021', 'Simulated emergency drill.', 4, '2025-08-15 09:00', '2025-08-02 09:00'),
('Neighborhood Cleanup', 1, '33333 Clean St, Houston, TX 77022', 'Cleanup and beautification.', 3, '2025-08-20 08:00', '2025-08-05 10:00'),
('Tech Training', 1, '44444 Learn Ave, Houston, TX 77023', 'Training volunteers in tech skills.', 2, '2025-08-25 13:00', '2025-08-10 14:00'),

-- Admin 2: 3 events
('Food Drive', 2, '55555 Giveback Ln, Houston, TX 77024', 'Collecting food for the needy.', 4, '2025-08-18 11:00', '2025-08-05 13:00'),
('Coordination Workshop', 2, '66666 Teamwork Rd, Houston, TX 77025', 'Workshop on planning events.', 3, '2025-08-22 10:00', '2025-08-08 10:00'),
('Language Exchange', 2, '77777 Translate Blvd, Houston, TX 77026', 'Help bridge communication gaps.', 2, '2025-08-28 14:00', '2025-08-12 14:00'),

-- Admin 3: 2 events
('Mobile Clinic', 3, '88888 Health Dr, Houston, TX 77027', 'Provide first aid to remote communities.', 5, '2025-08-12 09:00', '2025-08-03 11:00'),
('Senior Tech Help', 3, '99999 Help Ct, Houston, TX 77028', 'Assist seniors with devices.', 1, '2025-08-30 15:00', '2025-08-15 10:00'),

-- Admin 4: 1 event
('Translation Station', 4, '12121 Language Rd, Houston, TX 77029', 'Volunteers provide translation support.', 3, '2025-08-16 11:00', '2025-08-04 12:00');

-- Populate TASK table (multiple per event, unique skills)
-- Event 1
INSERT INTO TASK (Event_ID, Name, Skill, Description) VALUES
(1, 'Set up First Aid Booth', ARRAY['First Aid'], 'Prepare the booth and supplies.'),
(1, 'Guide Participants', ARRAY['Communication'], 'Help participants find stations.'),

-- Event 2
(2, 'Disaster Planning', ARRAY['Coordination'], 'Coordinate response plans.'),
(2, 'Emergency Logistics', ARRAY['Logistics'], 'Manage emergency supplies.'),

-- Event 3
(3, 'Street Cleaning', ARRAY['Cleaning'], 'Sweep and collect litter.'),
(3, 'Trash Transport', ARRAY['Driving'], 'Drive trucks to carry waste.'),

-- Event 4
(4, 'Tech Setup', ARRAY['Tech Support'], 'Set up laptops and network.'),
(4, 'Registration', ARRAY['Scheduling'], 'Manage sign-ins.'),

-- Event 5
(5, 'Sort Donations', ARRAY['Teamwork'], 'Organize food packages.'),
(5, 'Load Vehicles', ARRAY['Driving'], 'Load trucks with donations.'),

-- Event 6
(6, 'Plan Agenda', ARRAY['Scheduling'], 'Create event schedule.'),
(6, 'Assign Roles', ARRAY['Coordination'], 'Distribute responsibilities.'),

-- Event 7
(7, 'Translate Flyers', ARRAY['Translation'], 'Translate materials.'),
(7, 'Interpret Live', ARRAY['Communication'], 'Assist with real-time interpreting.'),

-- Event 8
(8, 'Health Screening', ARRAY['First Aid'], 'Provide basic checks.'),
(8, 'Medical Forms', ARRAY['Communication'], 'Collect medical histories.'),

-- Event 9
(9, 'Setup Devices', ARRAY['Tech Support'], 'Install apps and configure devices.'),
(9, 'Train Users', ARRAY['Event Planning'], 'Teach device usage.'),

-- Event 10
(10, 'Language Support', ARRAY['Translation'], 'Translate for visitors.'),
(10, 'Scheduling Help', ARRAY['Scheduling'], 'Help with appointment setting.');

-- Sample VOLUNTEER_TASK (mapping volunteers to tasks)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
(1, 6, '2025-08-01 10:00'),
(2, 7, '2025-08-02 10:30'),
(3, 8, '2025-08-03 09:00'),
(4, 9, '2025-08-03 11:00'),
(5, 10, '2025-08-04 08:00'),
(6, 11, '2025-08-05 13:00'),
(7, 12, '2025-08-06 14:00'),
(8, 13, '2025-08-07 15:00'),
(9, 14, '2025-08-08 16:00'),
(10, 15, '2025-08-09 17:00');

-- Sample VOLUNTEER_HIST (recording work sessions)
INSERT INTO VOLUNTEER_HIST (V_task_ID, Start_time, End_Time) VALUES
(1, '2025-08-10 09:00', '2025-08-10 12:00'),
(2, '2025-08-15 08:30', '2025-08-15 11:30'),
(3, '2025-08-20 07:45', '2025-08-20 10:00'),
(4, '2025-08-25 12:30', '2025-08-25 15:00');
