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

-- Insert Roles
INSERT INTO ROLE (Name) VALUES 
('Admin'),
('Regular');

-- Insert Volunteers (5 Admins + 15 Regulars = 20 total)
-- Admin Volunteers (Role_ID = 1)
INSERT INTO VOLUNTEER (Role_ID, First_name, Last_name, Username, Email, Password, Skill, Location, Availability, Date_enrolled) VALUES
(1, 'Sarah', 'Johnson', 'sjohnson', 'sarah.johnson@email.com', crypt('AdminPass123!', gen_salt('bf')), 
 ARRAY['First Aid', 'Coordination', 'Event Planning'], '1425 Oak Street, Houston, TX 77002', 
 ARRAY['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'], '2023-01-15'),

(1, 'Michael', 'Chen', 'mchen', 'michael.chen@email.com', crypt('SecureAdmin456#', gen_salt('bf')), 
 ARRAY['Logistics', 'Scheduling', 'Tech Support'], '2847 Pine Avenue, Austin, TX 78701', 
 ARRAY['Tuesday', 'Wednesday', 'Thursday', 'Saturday', 'Sunday'], '2023-02-20'),

(1, 'Emily', 'Rodriguez', 'erodriguez', 'emily.rodriguez@email.com', crypt('AdminKey789$', gen_salt('bf')), 
 ARRAY['Communication', 'Event Planning', 'Teamwork'], '3691 Maple Drive, Dallas, TX 75201', 
 ARRAY['Monday', 'Wednesday', 'Friday', 'Saturday'], '2023-03-10'),

(1, 'David', 'Thompson', 'dthompson', 'david.thompson@email.com', crypt('PowerAdmin321&', gen_salt('bf')), 
 ARRAY['Coordination', 'Logistics', 'Communication'], '4512 Elm Boulevard, San Antonio, TX 78205', 
 ARRAY['Thursday', 'Friday', 'Saturday', 'Sunday'], '2023-04-05'),

(1, 'Lisa', 'Williams', 'lwilliams', 'lisa.williams@email.com', crypt('AdminForce654*', gen_salt('bf')), 
 ARRAY['First Aid', 'Event Planning', 'Driving'], '5678 Cedar Lane, Fort Worth, TX 76102', 
 ARRAY['Monday', 'Tuesday', 'Thursday', 'Sunday'], '2023-05-12'),

-- Regular Volunteers (Role_ID = 2)
(2, 'James', 'Brown', 'jbrown', 'james.brown@email.com', crypt('VolunteerPass987!', gen_salt('bf')), 
 ARRAY['First Aid', 'Teamwork', 'Communication'], '6789 Birch Street, Plano, TX 75023', 
 ARRAY['Saturday', 'Sunday', 'Monday'], '2023-06-01'),

(2, 'Maria', 'Garcia', 'mgarcia', 'maria.garcia@email.com', crypt('HelpingHand123@', gen_salt('bf')), 
 ARRAY['Translation', 'Communication', 'Teamwork'], '7890 Willow Court, Irving, TX 75061', 
 ARRAY['Tuesday', 'Thursday', 'Saturday'], '2023-06-15'),

(2, 'Robert', 'Davis', 'rdavis', 'robert.davis@email.com', crypt('ServiceFirst456#', gen_salt('bf')), 
 ARRAY['Driving', 'Logistics', 'Cleaning'], '8901 Spruce Avenue, Arlington, TX 76010', 
 ARRAY['Friday', 'Saturday', 'Sunday'], '2023-07-02'),

(2, 'Jennifer', 'Miller', 'jmiller', 'jennifer.miller@email.com', crypt('CommunityHelp789$', gen_salt('bf')), 
 ARRAY['Event Planning', 'Coordination', 'Communication'], '9012 Ash Drive, Garland, TX 75040', 
 ARRAY['Wednesday', 'Thursday', 'Friday'], '2023-07-20'),

(2, 'Christopher', 'Wilson', 'cwilson', 'christopher.wilson@email.com', crypt('VolunteerSpirit321%', gen_salt('bf')), 
 ARRAY['Tech Support', 'Logistics', 'Teamwork'], '1234 Hickory Lane, Grand Prairie, TX 75050', 
 ARRAY['Monday', 'Tuesday', 'Saturday'], '2023-08-05'),

(2, 'Amanda', 'Moore', 'amoore', 'amanda.moore@email.com', crypt('GivingBack654&', gen_salt('bf')), 
 ARRAY['First Aid', 'Cleaning', 'Communication'], '2345 Poplar Street, Mesquite, TX 75149', 
 ARRAY['Sunday', 'Monday', 'Wednesday'], '2023-08-18'),

(2, 'Daniel', 'Taylor', 'dtaylor', 'daniel.taylor@email.com', crypt('HelpOthers987*', gen_salt('bf')), 
 ARRAY['Scheduling', 'Coordination', 'Driving'], '3456 Sycamore Road, Richardson, TX 75080', 
 ARRAY['Thursday', 'Friday', 'Sunday'], '2023-09-01'),

(2, 'Ashley', 'Anderson', 'aanderson', 'ashley.anderson@email.com', crypt('CommunityFirst123+', gen_salt('bf')), 
 ARRAY['Translation', 'Event Planning', 'Communication'], '4567 Magnolia Circle, Carrollton, TX 75006', 
 ARRAY['Tuesday', 'Wednesday', 'Saturday'], '2023-09-15'),

(2, 'Matthew', 'Thomas', 'mthomas', 'matthew.thomas@email.com', crypt('ServiceMinded456-', gen_salt('bf')), 
 ARRAY['Tech Support', 'First Aid', 'Logistics'], '5678 Dogwood Avenue, Lewisville, TX 75057', 
 ARRAY['Monday', 'Thursday', 'Friday'], '2023-10-02'),

(2, 'Jessica', 'Jackson', 'jjackson', 'jessica.jackson@email.com', crypt('VolunteerHeart789=', gen_salt('bf')), 
 ARRAY['Cleaning', 'Teamwork', 'Scheduling'], '6789 Redwood Boulevard, Flower Mound, TX 75028', 
 ARRAY['Wednesday', 'Saturday', 'Sunday'], '2023-10-20'),

(2, 'Andrew', 'White', 'awhite', 'andrew.white@email.com', crypt('MakeADifference321!', gen_salt('bf')), 
 ARRAY['Driving', 'Communication', 'Event Planning'], '7890 Oakwood Drive, Denton, TX 76201', 
 ARRAY['Tuesday', 'Thursday', 'Sunday'], '2023-11-01'),

(2, 'Nicole', 'Harris', 'nharris', 'nicole.harris@email.com', crypt('CommunityLove654@', gen_salt('bf')), 
 ARRAY['First Aid', 'Coordination', 'Translation'], '8901 Pine Ridge Court, Frisco, TX 75033', 
 ARRAY['Monday', 'Wednesday', 'Friday'], '2023-11-18'),

(2, 'Ryan', 'Martin', 'rmartin', 'ryan.martin@email.com', crypt('HelpingSpirit987#', gen_salt('bf')), 
 ARRAY['Logistics', 'Tech Support', 'Teamwork'], '9012 Cedar Creek Lane, McKinney, TX 75069', 
 ARRAY['Thursday', 'Saturday', 'Sunday'], '2023-12-05'),

(2, 'Stephanie', 'Clark', 'sclark', 'stephanie.clark@email.com', crypt('ServiceJoy321$', gen_salt('bf')), 
 ARRAY['Cleaning', 'Communication', 'Scheduling'], '1357 Willow Creek Road, Allen, TX 75013', 
 ARRAY['Tuesday', 'Friday', 'Saturday'], '2023-12-22'),

(2, 'Kevin', 'Lewis', 'klewis', 'kevin.lewis@email.com', crypt('CommunitySupport654%', gen_salt('bf')), 
 ARRAY['Event Planning', 'Driving', 'First Aid'], '2468 Maple Grove Avenue, Wylie, TX 75098', 
 ARRAY['Monday', 'Wednesday', 'Sunday'], '2024-01-10');

-- Insert Events (Distribution: Admin 1 = 4 events, Admin 2 = 3 events, Admin 3 = 2 events, Admin 4 = 1 event, Admin 5 = 0 events)
-- Events by Admin 1 (Sarah Johnson, ID = 1) - 4 events
INSERT INTO EVENT (Name, Moderator, Location, Description, Priority, Date, Date_published) VALUES
('Community Food Drive', 1, '1500 Main Street, Houston, TX 77003', 'Collecting and distributing food to families in need during the holiday season', 5, '2024-12-15 09:00:00', '2024-11-01 10:00:00'),
('Blood Donation Campaign', 1, '2200 Medical Center Boulevard, Houston, TX 77030', 'Organizing blood donation drives in partnership with local hospitals', 4, '2024-11-20 08:00:00', '2024-10-15 14:00:00'),
('Environmental Cleanup Day', 1, '3400 Buffalo Bayou Park, Houston, TX 77007', 'Cleaning up local parks and waterways to protect our environment', 3, '2024-10-25 07:30:00', '2024-09-20 09:00:00'),
('Senior Center Support', 1, '4600 Elderly Care Drive, Houston, TX 77004', 'Providing companionship and assistance to elderly residents', 2, '2024-09-30 13:00:00', '2024-08-25 11:00:00'),

-- Events by Admin 2 (Michael Chen, ID = 2) - 3 events
('Tech Literacy Workshop', 2, '1800 Education Boulevard, Austin, TX 78702', 'Teaching basic computer skills to underserved communities', 4, '2024-11-10 10:00:00', '2024-10-05 16:00:00'),
('Disaster Relief Training', 2, '2900 Emergency Services Road, Austin, TX 78703', 'Training volunteers for emergency response and disaster relief efforts', 5, '2024-12-01 08:00:00', '2024-10-20 12:00:00'),
('Youth Mentorship Program', 2, '3700 Community Center Lane, Austin, TX 78704', 'Mentoring at-risk youth through educational and recreational activities', 3, '2024-10-15 15:00:00', '2024-09-10 13:00:00'),

-- Events by Admin 3 (Emily Rodriguez, ID = 3) - 2 events
('Homeless Shelter Assistance', 3, '1900 Shelter Avenue, Dallas, TX 75202', 'Providing meals and support services to homeless individuals', 5, '2024-11-25 17:00:00', '2024-10-30 08:00:00'),
('Community Garden Project', 3, '2800 Garden Way, Dallas, TX 75203', 'Establishing community gardens to promote sustainable living', 2, '2024-10-05 09:00:00', '2024-09-01 15:00:00'),

-- Events by Admin 4 (David Thompson, ID = 4) - 1 event
('Animal Shelter Support', 4, '3500 Animal Care Street, San Antonio, TX 78206', 'Caring for abandoned animals and promoting pet adoption', 1, '2024-09-20 11:00:00', '2024-08-15 17:00:00');

-- Admin 5 (Lisa Williams, ID = 5) has 0 events as required

-- Insert Tasks for each Event (ensuring no NULL skills when consolidated per event)
-- Tasks for Community Food Drive (Event ID = 1)
INSERT INTO TASK (Event_ID, Name, Skill, Description) VALUES
(1, 'Food Collection Coordination', ARRAY['Coordination', 'Logistics', 'Communication'], 'Coordinate food collection from various donation points'),
(1, 'Volunteer Registration', ARRAY['Communication', 'Scheduling', 'Tech Support'], 'Register and schedule volunteers for different shifts'),
(1, 'Distribution Management', ARRAY['Event Planning', 'Teamwork', 'First Aid'], 'Manage food distribution to families and ensure safety protocols'),
(1, 'Transportation Services', ARRAY['Driving', 'Logistics', 'Cleaning'], 'Transport food donations and maintain clean vehicles'),

-- Tasks for Blood Donation Campaign (Event ID = 2)
(2, 'Medical Support', ARRAY['First Aid', 'Communication', 'Teamwork'], 'Provide medical assistance during blood donation process'),
(2, 'Donor Registration', ARRAY['Tech Support', 'Scheduling', 'Communication'], 'Register donors and manage appointment scheduling'),
(2, 'Site Preparation', ARRAY['Cleaning', 'Event Planning', 'Coordination'], 'Prepare donation sites and maintain cleanliness standards'),
(2, 'Language Support', ARRAY['Translation', 'Communication', 'Logistics'], 'Provide translation services for non-English speaking donors'),

-- Tasks for Environmental Cleanup Day (Event ID = 3)
(3, 'Team Leadership', ARRAY['Coordination', 'Teamwork', 'Event Planning'], 'Lead cleanup teams and coordinate activities'),
(3, 'Equipment Management', ARRAY['Logistics', 'Cleaning', 'Tech Support'], 'Manage cleanup equipment and track inventory'),
(3, 'Safety Coordination', ARRAY['First Aid', 'Communication', 'Scheduling'], 'Ensure volunteer safety and coordinate emergency response'),
(3, 'Transportation Coordination', ARRAY['Driving', 'Logistics', 'Translation'], 'Coordinate volunteer transportation and waste removal'),

-- Tasks for Senior Center Support (Event ID = 4)
(4, 'Activity Coordination', ARRAY['Event Planning', 'Communication', 'Teamwork'], 'Plan and coordinate activities for senior residents'),
(4, 'Meal Service', ARRAY['Cleaning', 'First Aid', 'Coordination'], 'Assist with meal preparation and service'),
(4, 'Technology Assistance', ARRAY['Tech Support', 'Communication', 'Scheduling'], 'Help seniors with technology and communication needs'),
(4, 'Transportation Services', ARRAY['Driving', 'Logistics', 'Translation'], 'Provide transportation for seniors to appointments'),

-- Tasks for Tech Literacy Workshop (Event ID = 5)
(5, 'Instruction Coordination', ARRAY['Tech Support', 'Communication', 'Event Planning'], 'Coordinate technology instruction and curriculum'),
(5, 'Equipment Setup', ARRAY['Tech Support', 'Logistics', 'Teamwork'], 'Set up computers and technology equipment'),
(5, 'Student Registration', ARRAY['Communication', 'Scheduling', 'Translation'], 'Register students and manage class schedules'),
(5, 'Technical Support', ARRAY['Tech Support', 'First Aid', 'Cleaning'], 'Provide ongoing technical support and maintain equipment'),

-- Tasks for Disaster Relief Training (Event ID = 6)
(6, 'Training Coordination', ARRAY['Coordination', 'Event Planning', 'Communication'], 'Coordinate training sessions and educational materials'),
(6, 'Safety Training', ARRAY['First Aid', 'Communication', 'Teamwork'], 'Conduct safety training and emergency response drills'),
(6, 'Resource Management', ARRAY['Logistics', 'Scheduling', 'Cleaning'], 'Manage training resources and facility maintenance'),
(6, 'Documentation Support', ARRAY['Tech Support', 'Translation', 'Driving'], 'Document training progress and provide multilingual support'),

-- Tasks for Youth Mentorship Program (Event ID = 7)
(7, 'Mentorship Coordination', ARRAY['Coordination', 'Communication', 'Event Planning'], 'Match mentors with youth and coordinate activities'),
(7, 'Activity Planning', ARRAY['Event Planning', 'Teamwork', 'Tech Support'], 'Plan educational and recreational activities'),
(7, 'Transportation Services', ARRAY['Driving', 'First Aid', 'Logistics'], 'Provide safe transportation for youth activities'),
(7, 'Program Support', ARRAY['Cleaning', 'Scheduling', 'Translation'], 'Support program operations and provide translation services'),

-- Tasks for Homeless Shelter Assistance (Event ID = 8)
(8, 'Meal Preparation', ARRAY['Cleaning', 'Coordination', 'Teamwork'], 'Prepare and serve meals to shelter residents'),
(8, 'Client Services', ARRAY['Communication', 'First Aid', 'Translation'], 'Provide client services and emergency medical assistance'),
(8, 'Facility Maintenance', ARRAY['Cleaning', 'Logistics', 'Tech Support'], 'Maintain shelter facilities and manage supplies'),
(8, 'Outreach Coordination', ARRAY['Event Planning', 'Driving', 'Scheduling'], 'Coordinate outreach efforts and transportation services'),

-- Tasks for Community Garden Project (Event ID = 9)
(9, 'Garden Planning', ARRAY['Event Planning', 'Coordination', 'Communication'], 'Plan garden layout and coordinate community involvement'),
(9, 'Site Preparation', ARRAY['Cleaning', 'Logistics', 'Teamwork'], 'Prepare garden sites and manage equipment'),
(9, 'Educational Workshops', ARRAY['Communication', 'Tech Support', 'Translation'], 'Conduct educational workshops on sustainable gardening'),
(9, 'Maintenance Coordination', ARRAY['Scheduling', 'First Aid', 'Driving'], 'Schedule maintenance activities and coordinate volunteer schedules'),

-- Tasks for Animal Shelter Support (Event ID = 10)
(10, 'Animal Care', ARRAY['First Aid', 'Cleaning', 'Communication'], 'Provide direct care for shelter animals'),
(10, 'Adoption Coordination', ARRAY['Communication', 'Event Planning', 'Tech Support'], 'Coordinate pet adoption events and maintain records'),
(10, 'Facility Maintenance', ARRAY['Cleaning', 'Logistics', 'Teamwork'], 'Maintain shelter facilities and manage supplies'),
(10, 'Volunteer Coordination', ARRAY['Coordination', 'Scheduling', 'Translation'], 'Schedule volunteers and provide multilingual support');

-- Insert Volunteer Task Assignments (realistic distribution)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
-- Community Food Drive assignments
(1, 1, '2024-11-02 09:00:00'), (1, 6, '2024-11-02 14:30:00'), (1, 11, '2024-11-03 10:15:00'),
(2, 7, '2024-11-02 16:20:00'), (2, 12, '2024-11-04 11:45:00'),
(3, 2, '2024-11-03 13:10:00'), (3, 8, '2024-11-03 15:25:00'), (3, 16, '2024-11-04 09:30:00'),
(4, 9, '2024-11-04 12:00:00'), (4, 18, '2024-11-05 08:15:00'),

-- Blood Donation Campaign assignments
(5, 3, '2024-10-16 10:30:00'), (5, 13, '2024-10-16 14:45:00'),
(6, 10, '2024-10-17 09:20:00'), (6, 19, '2024-10-17 16:10:00'),
(7, 4, '2024-10-18 11:35:00'), (7, 15, '2024-10-18 13:50:00'),
(8, 14, '2024-10-19 08:40:00'), (8, 20, '2024-10-19 15:15:00'),

-- Environmental Cleanup Day assignments
(9, 5, '2024-09-21 07:45:00'), (9, 17, '2024-09-21 12:30:00'),
(10, 6, '2024-09-22 09:55:00'), (10, 11, '2024-09-22 14:20:00'),
(11, 7, '2024-09-23 10:40:00'), (11, 12, '2024-09-23 16:05:00'),
(12, 8, '2024-09-24 08:25:00'), (12, 18, '2024-09-24 13:15:00'),

-- Senior Center Support assignments
(13, 9, '2024-08-26 11:10:00'), (13, 13, '2024-08-26 15:45:00'),
(14, 10, '2024-08-27 09:30:00'), (14, 16, '2024-08-27 12:55:00'),
(15, 14, '2024-08-28 14:15:00'), (15, 19, '2024-08-28 16:40:00'),
(16, 15, '2024-08-29 10:20:00'), (16, 20, '2024-08-29 13:35:00'),

-- Tech Literacy Workshop assignments
(17, 2, '2024-10-06 08:50:00'), (17, 17, '2024-10-06 11:25:00'),
(18, 11, '2024-10-07 13:40:00'), (18, 6, '2024-10-07 15:55:00'),
(19, 12, '2024-10-08 09:15:00'), (19, 7, '2024-10-08 14:30:00'),
(20, 18, '2024-10-09 10:45:00'), (20, 8, '2024-10-09 16:20:00'),

-- Disaster Relief Training assignments
(21, 1, '2024-10-21 12:05:00'), (21, 13, '2024-10-21 14:50:00'),
(22, 9, '2024-10-22 08:35:00'), (22, 16, '2024-10-22 11:10:00'),
(23, 14, '2024-10-23 15:25:00'), (23, 19, '2024-10-23 17:40:00'),
(24, 15, '2024-10-24 09:00:00'), (24, 20, '2024-10-24 12:15:00'),

-- Youth Mentorship Program assignments
(25, 3, '2024-09-11 10:25:00'), (25, 10, '2024-09-11 13:45:00'),
(26, 17, '2024-09-12 11:50:00'), (26, 6, '2024-09-12 16:15:00'),
(27, 11, '2024-09-13 08:30:00'), (27, 18, '2024-09-13 14:55:00'),
(28, 12, '2024-09-14 12:40:00'), (28, 7, '2024-09-14 15:05:00'),

-- Homeless Shelter Assistance assignments
(29, 4, '2024-10-31 09:20:00'), (29, 8, '2024-10-31 12:35:00'),
(30, 13, '2024-11-01 14:10:00'), (30, 16, '2024-11-01 16:45:00'),
(31, 14, '2024-11-02 10:55:00'), (31, 19, '2024-11-02 13:20:00'),
(32, 15, '2024-11-03 11:40:00'), (32, 20, '2024-11-03 15:15:00'),

-- Community Garden Project assignments
(33, 5, '2024-09-02 08:45:00'), (33, 9, '2024-09-02 11:30:00'),
(34, 10, '2024-09-03 13:55:00'), (34, 17, '2024-09-03 16:20:00'),
(35, 6, '2024-09-04 09:40:00'), (35, 11, '2024-09-04 12:05:00'),
(36, 18, '2024-09-05 14:25:00'), (36, 12, '2024-09-05 16:50:00'),

-- Animal Shelter Support assignments
(37, 1, '2024-08-16 10:15:00'), (37, 7, '2024-08-16 13:40:00'),
(38, 8, '2024-08-17 11:25:00'), (38, 13, '2024-08-17 15:50:00'),
(39, 14, '2024-08-18 09:35:00'), (39, 16, '2024-08-18 12:00:00'),
(40, 19, '2024-08-19 14:45:00'), (40, 20, '2024-08-19 17:10:00');

-- Insert Volunteer History (work sessions)
INSERT INTO VOLUNTEER_HIST (V_task_ID, Start_time, End_Time) VALUES
-- Completed sessions
(1, '2024-11-15 09:00:00', '2024-11-15 13:00:00'),
(2, '2024-11-15 09:30:00', '2024-11-15 12:30:00'),
(3, '2024-11-15 10:00:00', '2024-11-15 14:00:00'),
(4, '2024-11-15 11:00:00', '2024-11-15 15:00:00'),
(5, '2024-11-15 12:00:00', '2024-11-15 16:00:00'),

(6, '2024-11-20 08:00:00', '2024-11-20 12:00:00'),
(7, '2024-11-20 08:30:00', '2024-11-20 11:30:00'),
(8, '2024-11-20 09:00:00', '2024-11-20 13:00:00'),
(9, '2024-11-20 09:30:00', '2024-11-20 12:30:00'),
(10, '2024-11-20 10:00:00', '2024-11-20 14:00:00'),

(11, '2024-10-25 07:30:00', '2024-10-25 11:30:00'),
(12, '2024-10-25 08:00:00', '2024-10-25 12:00:00'),
(13, '2024-10-25 08:30:00', '2024-10-25 12:30:00'),
(14, '2024-10-25 09:00:00', '2024-10-25 13:00:00'),
(15, '2024-10-25 09:30:00', '2024-10-25 13:30:00'),

(16, '2024-09-30 13:00:00', '2024-09-30 17:00:00'),
(17, '2024-09-30 13:30:00', '2024-09-30 16:30:00'),
(18, '2024-09-30 14:00:00', '2024-09-30 18:00:00'),
(19, '2024-09-30 14:30:00', '2024-09-30 17:30:00'),
(20, '2024-09-30 15:00:00', '2024-09-30 19:00:00'),

(21, '2024-11-10 10:00:00', '2024-11-10 14:00:00'),
(22, '2024-11-10 10:30:00', '2024-11-10 13:30:00'),
(23, '2024-11-10 11:00:00', '2024-11-10 15:00:00'),
(24, '2024-11-10 11:30:00', '2024-11-10 14:30:00'),
(25, '2024-11-10 12:00:00', '2024-11-10 16:00:00'),

(26, '2024-12-01 08:00:00', '2024-12-01 12:00:00'),
(27, '2024-12-01 08:30:00', '2024-12-01 11:30:00'),
(28, '2024-12-01 09:00:00', '2024-12-01 13:00:00'),
(29, '2024-12-01 09:30:00', '2024-12-01 12:30:00'),
(30, '2024-12-01 10:00:00', '2024-12-01 14:00:00'),

(31, '2024-10-15 15:00:00', '2024-10-15 19:00:00'),
(32, '2024-10-15 15:30:00', '2024-10-15 18:30:00'),
(33, '2024-10-15 16:00:00', '2024-10-15 20:00:00'),
(34, '2024-10-15 16:30:00', '2024-10-15 19:30:00'),
(35, '2024-10-15 17:00:00', '2024-10-15 21:00:00'),

(36, '2024-11-25 17:00:00', '2024-11-25 21:00:00'),
(37, '2024-11-25 17:30:00', '2024-11-25 20:30:00'),
(38, '2024-11-25 18:00:00', '2024-11-25 22:00:00'),
(39, '2024-11-25 18:30:00', '2024-11-25 21:30:00'),
(40, '2024-11-25 19:00:00', '2024-11-25 23:00:00'),

(41, '2024-10-05 09:00:00', '2024-10-05 13:00:00'),
(42, '2024-10-05 09:30:00', '2024-10-05 12:30:00'),
(43, '2024-10-05 10:00:00', '2024-10-05 14:00:00'),
(44, '2024-10-05 10:30:00', '2024-10-05 13:30:00'),
(45, '2024-10-05 11:00:00', '2024-10-05 15:00:00'),

(46, '2024-09-20 11:00:00', '2024-09-20 15:00:00'),
(47, '2024-09-20 11:30:00', '2024-09-20 14:30:00'),
(48, '2024-09-20 12:00:00', '2024-09-20 16:00:00'),
(49, '2024-09-20 12:30:00', '2024-09-20 15:30:00'),
(50, '2024-09-20 13:00:00', '2024-09-20 17:00:00');

-- Verification queries to confirm data integrity
-- SELECT 'Role Distribution' as Check_Type, Name as Role_Name, COUNT(*) as Count 
-- FROM ROLE r JOIN VOLUNTEER v ON r.ID = v.Role_ID GROUP BY r.Name;

-- SELECT 'Event Distribution by Admin' as Check_Type, 
--        CONCAT(v.First_name, ' ', v.Last_name) as Admin_Name, 
--        COUNT(e.ID) as Event_Count
-- FROM VOLUNTEER v LEFT JOIN EVENT e ON v.ID = e.Moderator 
-- WHERE v.Role_ID = 1 GROUP BY v.ID, v.First_name, v.Last_name ORDER BY Event_Count DESC;

-- SELECT 'Priority Distribution' as Check_Type, Priority, COUNT(*) as Count 
-- FROM EVENT GROUP BY Priority ORDER BY Priority;

-- SELECT 'Skills Coverage Check' as Check_Type, Event_ID, 
--        ARRAY_AGG(DISTINCT unnest) as All_Skills_Needed
-- FROM (SELECT Event_ID, unnest(Skill) FROM TASK) skills 
-- GROUP BY Event_ID;