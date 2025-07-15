/*
20 Volunteers:
	15 regular volunteers (Role_ID = 1)
	5 admins (Role_ID = 2)

Admin Event Distribution:
	Maria (Admin): Moderating 3 events (most active)
	James (Admin): Moderating 2 events
	Lisa (Admin): Moderating 1 event
	Daniel (Admin): Moderating 1 event
	Rachel (Admin): No events yet (available for future assignments)
*/

-- Insert roles
INSERT INTO ROLE (Name) VALUES 
('Volunteer'),
('Admin');

-- Insert volunteers (15 regular volunteers + 5 admins = 20 total)
-- Regular Volunteers (Role_ID = 1)
INSERT INTO VOLUNTEER (Role_ID, First_name, Last_name, Username, Email, Password, Skill, Location, Availability) VALUES
(1, 'Sarah', 'Johnson', 'sarahj', 'sarah.johnson@email.com', crypt('password123', gen_salt('bf')), 
 ARRAY['Communication', 'Event Planning'], ST_GeogFromText('POINT(-95.3698 29.7604)'), ARRAY['Monday', 'Wednesday', 'Friday']),

(1, 'Michael', 'Chen', 'mikec', 'michael.chen@email.com', crypt('securepass', gen_salt('bf')), 
 ARRAY['Technology', 'Photography'], ST_GeogFromText('POINT(-95.4194 29.7752)'), ARRAY['Tuesday', 'Thursday', 'Saturday']),

(1, 'Emily', 'Rodriguez', 'emilyr', 'emily.rodriguez@email.com', crypt('mypassword', gen_salt('bf')), 
 ARRAY['Teaching', 'Translation'], ST_GeogFromText('POINT(-95.3892 29.7372)'), ARRAY['Monday', 'Tuesday', 'Sunday']),

(1, 'David', 'Thompson', 'davidt', 'david.thompson@email.com', crypt('volunteer1', gen_salt('bf')), 
 ARRAY['Construction', 'Manual Labor'], ST_GeogFromText('POINT(-95.2688 29.6947)'), ARRAY['Saturday', 'Sunday']),

(1, 'Jessica', 'Martinez', 'jessicam', 'jessica.martinez@email.com', crypt('helper123', gen_salt('bf')), 
 ARRAY['Cooking', 'Event Planning'], ST_GeogFromText('POINT(-95.5588 29.7869)'), ARRAY['Wednesday', 'Friday', 'Saturday']),

(1, 'Robert', 'Wilson', 'robertw', 'robert.wilson@email.com', crypt('volunteer2', gen_salt('bf')), 
 ARRAY['First Aid', 'Sports'], ST_GeogFromText('POINT(-95.4431 29.6616)'), ARRAY['Thursday', 'Friday', 'Sunday']),

(1, 'Amanda', 'Brown', 'amandab', 'amanda.brown@email.com', crypt('brownbear', gen_salt('bf')), 
 ARRAY['Art', 'Crafts'], ST_GeogFromText('POINT(-95.1743 29.7321)'), ARRAY['Monday', 'Saturday']),

(1, 'Christopher', 'Garcia', 'chrisg', 'chris.garcia@email.com', crypt('garcia456', gen_salt('bf')), 
 ARRAY['Music', 'Entertainment'], ST_GeogFromText('POINT(-95.4895 29.8174)'), ARRAY['Tuesday', 'Wednesday', 'Thursday']),

(1, 'Michelle', 'Davis', 'michelled', 'michelle.davis@email.com', crypt('davis789', gen_salt('bf')), 
 ARRAY['Childcare', 'Education'], ST_GeogFromText('POINT(-95.2077 29.6836)'), ARRAY['Monday', 'Friday']),

(1, 'Anthony', 'Miller', 'anthonym', 'anthony.miller@email.com', crypt('miller321', gen_salt('bf')), 
 ARRAY['Transportation', 'Logistics'], ST_GeogFromText('POINT(-95.6379 29.7328)'), ARRAY['Saturday', 'Sunday']),

(1, 'Lauren', 'Anderson', 'laurena', 'lauren.anderson@email.com', crypt('anderson1', gen_salt('bf')), 
 ARRAY['Social Media', 'Marketing'], ST_GeogFromText('POINT(-95.3273 29.8077)'), ARRAY['Tuesday', 'Thursday']),

(1, 'Kevin', 'Taylor', 'kevint', 'kevin.taylor@email.com', crypt('taylor123', gen_salt('bf')), 
 ARRAY['Fundraising', 'Sales'], ST_GeogFromText('POINT(-95.5179 29.6458)'), ARRAY['Wednesday', 'Saturday', 'Sunday']),

(1, 'Nicole', 'Thomas', 'nicolet', 'nicole.thomas@email.com', crypt('thomas456', gen_salt('bf')), 
 ARRAY['Writing', 'Documentation'], ST_GeogFromText('POINT(-95.2943 29.7397)'), ARRAY['Monday', 'Tuesday', 'Friday']),

(1, 'Brandon', 'Jackson', 'brandonj', 'brandon.jackson@email.com', crypt('jackson789', gen_salt('bf')), 
 ARRAY['Security', 'Crowd Control'], ST_GeogFromText('POINT(-95.4688 29.7102)'), ARRAY['Thursday', 'Friday', 'Saturday']),

(1, 'Stephanie', 'White', 'stephw', 'stephanie.white@email.com', crypt('white321', gen_salt('bf')), 
 ARRAY['Health', 'Wellness'], ST_GeogFromText('POINT(-95.3955 29.6644)'), ARRAY['Sunday', 'Monday', 'Wednesday']),

-- Admin Volunteers (Role_ID = 2)
(2, 'Maria', 'Gonzalez', 'mariag', 'maria.gonzalez@email.com', crypt('admin123', gen_salt('bf')), 
 ARRAY['Leadership', 'Project Management'], ST_GeogFromText('POINT(-95.3698 29.7604)'), ARRAY['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']),

(2, 'James', 'Lee', 'jamesl', 'james.lee@email.com', crypt('adminpass', gen_salt('bf')), 
 ARRAY['Administration', 'Finance'], ST_GeogFromText('POINT(-95.4017 29.7755)'), ARRAY['Monday', 'Wednesday', 'Friday', 'Saturday']),

(2, 'Lisa', 'Harris', 'lisah', 'lisa.harris@email.com', crypt('harris456', gen_salt('bf')), 
 ARRAY['HR', 'Coordination'], ST_GeogFromText('POINT(-95.3365 29.7282)'), ARRAY['Tuesday', 'Thursday', 'Saturday', 'Sunday']),

(2, 'Daniel', 'Clark', 'danielc', 'daniel.clark@email.com', crypt('clark789', gen_salt('bf')), 
 ARRAY['Operations', 'Logistics'], ST_GeogFromText('POINT(-95.4715 29.6947)'), ARRAY['Monday', 'Tuesday', 'Friday', 'Sunday']),

(2, 'Rachel', 'Lewis', 'rachell', 'rachel.lewis@email.com', crypt('lewis321', gen_salt('bf')), 
 ARRAY['Communications', 'Public Relations'], ST_GeogFromText('POINT(-95.2943 29.8077)'), ARRAY['Wednesday', 'Thursday', 'Friday', 'Saturday']);

-- Insert events with varying moderator assignments
-- Maria (ID 16) - moderating multiple events
INSERT INTO EVENT (Name, Moderator, Location, Description, Date) VALUES
('Houston Food Drive', 16, ST_GeogFromText('POINT(-95.3698 29.7604)'), 'Community food collection for local food banks.', '2024-12-15 09:00:00'),
('Holiday Toy Distribution', 16, ST_GeogFromText('POINT(-95.4194 29.7752)'), 'Distributing toys to families in need during holidays.', '2024-12-20 14:00:00'),
('New Year Community Cleanup', 16, ST_GeogFromText('POINT(-95.3892 29.7372)'), 'Neighborhood cleanup initiative for the new year.', '2025-01-05 08:00:00'),

-- James (ID 17) - moderating multiple events
('Senior Citizens Support', 17, ST_GeogFromText('POINT(-95.2688 29.6947)'), 'Assistance program for elderly community members.', '2024-12-18 10:00:00'),
('Youth Mentorship Program', 17, ST_GeogFromText('POINT(-95.5588 29.7869)'), 'Pairing volunteers with local youth for mentoring.', '2025-01-12 15:00:00'),

-- Lisa (ID 18) - moderating one event
('Community Garden Project', 18, ST_GeogFromText('POINT(-95.4431 29.6616)'), 'Building and maintaining community gardens.', '2025-01-08 11:00:00'),

-- Daniel (ID 19) - moderating one event
('Disaster Preparedness Workshop', 19, ST_GeogFromText('POINT(-95.1743 29.7321)'), 'Teaching community disaster preparedness skills.', '2025-01-15 13:00:00');

-- Rachel (ID 20) - has not moderated any events yet (no entries)

-- Insert tasks for each event
-- Event 1: Houston Food Drive (Event ID 1)
INSERT INTO TASK (Event_ID, Skill, Description) VALUES
(1, ARRAY['Manual Labor', 'Transportation'], 'Loading and transporting food donations.'),
(1, ARRAY['Communication', 'Customer Service'], 'Greeting donors and managing donation intake.'),
(1, ARRAY['Organization', 'Logistics'], 'Sorting and organizing collected food items.'),

-- Event 2: Holiday Toy Distribution (Event ID 2)
(2, ARRAY['Childcare', 'Entertainment'], 'Entertaining children while parents register.'),
(2, ARRAY['Organization', 'Customer Service'], 'Managing toy distribution and family registration.'),

-- Event 3: New Year Community Cleanup (Event ID 3)
(3, ARRAY['Manual Labor', 'Environment'], 'Picking up litter and debris.'),
(3, ARRAY['Leadership', 'Coordination'], 'Coordinating cleanup teams and supplies.'),

-- Event 4: Senior Citizens Support (Event ID 4)
(4, ARRAY['Transportation', 'Customer Service'], 'Providing transportation for seniors.'),
(4, ARRAY['Health', 'Companionship'], 'Visiting and providing companionship to seniors.'),
(4, ARRAY['Technology', 'Teaching'], 'Teaching technology skills to seniors.'),

-- Event 5: Youth Mentorship Program (Event ID 5)
(5, ARRAY['Education', 'Mentoring'], 'One-on-one mentoring sessions with youth.'),
(5, ARRAY['Sports', 'Recreation'], 'Organizing recreational activities.'),
(5, ARRAY['Arts', 'Creativity'], 'Leading creative workshops and activities.'),

-- Event 6: Community Garden Project (Event ID 6)
(6, ARRAY['Gardening', 'Manual Labor'], 'Planting and maintaining garden beds.'),
(6, ARRAY['Construction', 'Tools'], 'Building garden infrastructure.'),
(6, ARRAY['Education', 'Environment'], 'Teaching sustainable gardening practices.'),

-- Event 7: Disaster Preparedness Workshop (Event ID 7)
(7, ARRAY['First Aid', 'Emergency Response'], 'Teaching first aid and emergency response.'),
(7, ARRAY['Communication', 'Public Speaking'], 'Presenting preparedness information.'),
(7, ARRAY['Organization', 'Planning'], 'Organizing workshop materials and schedule.');

-- Insert volunteer task assignments (volunteers accepting tasks)
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted) VALUES
-- Food Drive assignments
(1, 4, '2024-12-10 14:30:00'),  -- David for loading/transport
(1, 10, '2024-12-10 16:45:00'), -- Anthony for loading/transport
(2, 1, '2024-12-11 09:15:00'),  -- Sarah for donor greeting
(2, 11, '2024-12-11 10:30:00'), -- Lauren for donor greeting
(3, 3, '2024-12-12 11:20:00'),  -- Emily for sorting

-- Holiday Toy Distribution assignments
(4, 9, '2024-12-15 13:45:00'),  -- Michelle for childcare
(4, 8, '2024-12-15 14:20:00'),  -- Christopher for entertainment
(5, 5, '2024-12-16 08:30:00'),  -- Jessica for distribution

-- Community Cleanup assignments
(6, 4, '2024-12-20 07:45:00'),  -- David for manual labor
(6, 14, '2024-12-20 08:15:00'), -- Brandon for manual labor
(7, 16, '2024-12-21 10:00:00'), -- Maria for coordination

-- Senior Citizens Support assignments
(8, 10, '2024-12-12 15:30:00'), -- Anthony for transportation
(9, 15, '2024-12-13 09:45:00'), -- Stephanie for companionship
(10, 2, '2024-12-13 14:20:00'), -- Michael for technology teaching

-- Youth Mentorship assignments
(11, 3, '2024-12-18 11:00:00'), -- Emily for mentoring
(11, 9, '2024-12-18 13:30:00'), -- Michelle for mentoring
(12, 6, '2024-12-19 10:15:00'), -- Robert for sports
(13, 7, '2024-12-19 16:45:00'), -- Amanda for arts

-- Community Garden assignments
(14, 4, '2024-12-22 08:30:00'), -- David for gardening
(15, 4, '2024-12-22 09:00:00'), -- David also for construction
(16, 3, '2024-12-23 11:15:00'), -- Emily for teaching

-- Disaster Preparedness assignments
(17, 6, '2024-12-28 14:00:00'), -- Robert for first aid
(18, 1, '2024-12-28 15:30:00'), -- Sarah for presenting
(19, 12, '2024-12-29 09:45:00'); -- Kevin for organizing

-- Insert some completed volunteer history
INSERT INTO VOLUNTEER_HIST (V_task_ID, Start_time, End_Time) VALUES
-- Completed assignments from previous events
(1, '2024-12-15 09:00:00', '2024-12-15 12:30:00'),  -- David's transport task
(2, '2024-12-15 09:00:00', '2024-12-15 13:00:00'),  -- Sarah's greeting task
(3, '2024-12-15 13:30:00', '2024-12-15 16:00:00'),  -- Emily's sorting task
(4, '2024-12-20 14:00:00', '2024-12-20 16:30:00'),  -- Michelle's childcare
(5, '2024-12-20 14:00:00', '2024-12-20 17:00:00'),  -- Jessica's distribution
(8, '2024-12-18 10:00:00', '2024-12-18 15:00:00'),  -- Anthony's transportation
(9, '2024-12-18 10:30:00', '2024-12-18 14:30:00');  -- Stephanie's companionship