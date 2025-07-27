-- Insert roles
INSERT INTO ROLE (Name) VALUES
('Admin'),
('Volunteer');

-- Insert volunteers (5 admins + 15 volunteers)
INSERT INTO VOLUNTEER (Role_ID, First_name, Last_name, Username, Email, Password, Skill, Location, Availability) VALUES
-- Admins
(1, 'Alice',   'Johnson', 'alicej',   'alice@example.com',   crypt('password1', gen_salt('bf')), ARRAY['Leadership', 'Organization'], ST_GeogFromText('SRID=4326;POINT(-95.3698 29.7604)'), ARRAY['Weekends']),
(1, 'Bob',     'Smith',   'bobsmith', 'bob@example.com',     crypt('password2', gen_salt('bf')), ARRAY['Planning', 'Coordination'], ST_GeogFromText('SRID=4326;POINT(-95.4242 29.7609)'), ARRAY['Weekdays']),
(1, 'Carla',   'Nguyen',  'cnguyen',  'carla@example.com',   crypt('password3', gen_salt('bf')), ARRAY['Budgeting', 'Scheduling'], ST_GeogFromText('SRID=4326;POINT(-95.3610 29.7499)'), ARRAY['Weekends']),
(1, 'David',   'Lee',     'dlee',     'david@example.com',   crypt('password4', gen_salt('bf')), ARRAY['Logistics', 'Supervision'], ST_GeogFromText('SRID=4326;POINT(-95.4475 29.7370)'), ARRAY['Weekdays']),
(1, 'Emily',   'Brown',   'ebrown',   'emily@example.com',   crypt('password5', gen_salt('bf')), ARRAY['Fundraising', 'Public Speaking'], ST_GeogFromText('SRID=4326;POINT(-95.3584 29.7520)'), ARRAY['Evenings']),

-- Regular volunteers
(2, 'Frank',   'Green',   'fgreen',   'frank@example.com',   crypt('vol123', gen_salt('bf')), ARRAY['Photography'], ST_GeogFromText('SRID=4326;POINT(-95.4698 29.7600)'), ARRAY['Weekends']),
(2, 'Grace',   'Hill',    'ghill',    'grace@example.com',   crypt('vol234', gen_salt('bf')), ARRAY['Cooking'], ST_GeogFromText('SRID=4326;POINT(-95.3398 29.7501)'), ARRAY['Weekdays']),
(2, 'Henry',   'Jones',   'hjones',   'henry@example.com',   crypt('vol345', gen_salt('bf')), ARRAY['First Aid'], ST_GeogFromText('SRID=4326;POINT(-95.3790 29.7354)'), ARRAY['Weekends']),
(2, 'Isla',    'King',    'iking',    'isla@example.com',    crypt('vol456', gen_salt('bf')), ARRAY['Sign Language'], ST_GeogFromText('SRID=4326;POINT(-95.4099 29.7721)'), ARRAY['Weekends']),
(2, 'Jack',    'Long',    'jlong',    'jack@example.com',    crypt('vol567', gen_salt('bf')), ARRAY['Driving'], ST_GeogFromText('SRID=4326;POINT(-95.3870 29.7812)'), ARRAY['Evenings']),
(2, 'Karen',   'Moore',   'kmoore',   'karen@example.com',   crypt('vol678', gen_salt('bf')), ARRAY['Organization', 'Photography'], ST_GeogFromText('SRID=4326;POINT(-95.4090 29.7904)'), ARRAY['Weekdays']),
(2, 'Leo',     'Nelson',  'lnelson',  'leo@example.com',     crypt('vol789', gen_salt('bf')), ARRAY['Teaching'], ST_GeogFromText('SRID=4326;POINT(-95.3200 29.7655)'), ARRAY['Mornings']),
(2, 'Mona',    'Ortiz',   'mortiz',   'mona@example.com',    crypt('vol890', gen_salt('bf')), ARRAY['Child Care'], ST_GeogFromText('SRID=4326;POINT(-95.3100 29.7720)'), ARRAY['Weekends']),
(2, 'Nina',    'Patel',   'npatel',   'nina@example.com',    crypt('vol901', gen_salt('bf')), ARRAY['Coordination'], ST_GeogFromText('SRID=4326;POINT(-95.4300 29.7400)'), ARRAY['Afternoons']),
(2, 'Omar',    'Quinn',   'oquinn',   'omar@example.com',    crypt('vol012', gen_salt('bf')), ARRAY['Logistics'], ST_GeogFromText('SRID=4326;POINT(-95.3700 29.7550)'), ARRAY['Weekdays']),
(2, 'Paula',   'Reed',    'preed',    'paula@example.com',   crypt('vol1234', gen_salt('bf')), ARRAY['Event Setup'], ST_GeogFromText('SRID=4326;POINT(-95.4000 29.7450)'), ARRAY['Weekends']),
(2, 'Quinn',   'Stone',   'qstone',   'quinn@example.com',   crypt('vol2345', gen_salt('bf')), ARRAY['Fundraising'], ST_GeogFromText('SRID=4326;POINT(-95.3700 29.7650)'), ARRAY['Evenings']),
(2, 'Rachel',  'Thomas',  'rthomas',  'rachel@example.com',  crypt('vol3456', gen_salt('bf')), ARRAY['Cooking', 'Driving'], ST_GeogFromText('SRID=4326;POINT(-95.3650 29.7500)'), ARRAY['Weekdays']);


-- Insert events created by some admins
INSERT INTO EVENT (Name, Moderator, Location, Description, Priority, Date) VALUES
('Cleanup Drive', 1, ST_GeogFromText('SRID=4326;POINT(-95.3584 29.7499)'), 'Neighborhood cleanup and waste collection', 3, '2025-08-05 10:00:00'),
('Food Distribution', 1, ST_GeogFromText('SRID=4326;POINT(-95.3652 29.7516)'), 'Distributing meals to underserved areas', 5, '2025-08-10 12:00:00'),
('Park Restoration', 1, ST_GeogFromText('SRID=4326;POINT(-95.3728 29.7489)'), 'Planting trees and painting benches in parks', 4, '2025-08-15 09:00:00'),

('Blood Drive', 2, ST_GeogFromText('SRID=4326;POINT(-95.4241 29.7524)'), 'Organizing a local blood donation camp', 4, '2025-08-20 11:00:00'),
('Youth Workshop', 2, ST_GeogFromText('SRID=4326;POINT(-95.4391 29.7452)'), 'Educating youth on career planning', 2, '2025-08-25 14:00:00'),

('Community Potluck', 3, ST_GeogFromText('SRID=4326;POINT(-95.4100 29.7700)'), 'Residents come together to share meals', 3, '2025-09-01 18:00:00');


-- Insert tasks linked to events
INSERT INTO TASK (Event_ID, Name, Skill, Description) VALUES
(1, 'Trash Collection', ARRAY['Driving', 'Organization'], 'Collect and transport trash to disposal sites'),
(1, 'Team Lead', ARRAY['Leadership', 'Coordination'], 'Lead a cleanup team and assign zones'),

(2, 'Meal Packing', ARRAY['Cooking', 'Coordination'], 'Prepare and pack food for distribution'),
(2, 'Logistics Coordination', ARRAY['Logistics', 'Driving'], 'Coordinate delivery routes and volunteers'),

(3, 'Tree Planting', ARRAY['Physical Labor', 'Gardening'], 'Assist in planting trees in local parks'),
(3, 'Bench Painting', ARRAY['Painting', 'Event Setup'], 'Paint benches and playground structures'),

(4, 'Donor Assistance', ARRAY['First Aid', 'Coordination'], 'Assist and monitor donors at the site'),
(4, 'Registration Desk', ARRAY['Organization', 'Public Speaking'], 'Register donors and provide information'),

(5, 'Workshop Facilitation', ARRAY['Teaching', 'Public Speaking'], 'Conduct interactive sessions with youth'),
(5, 'Setup and Breakdown', ARRAY['Event Setup', 'Logistics'], 'Manage the physical setup of the workshop'),

(6, 'Food Coordination', ARRAY['Cooking', 'Organization'], 'Coordinate potluck dish assignments'),
(6, 'Photography', ARRAY['Photography', 'Sign Language'], 'Document the event and assist with accessibility');
