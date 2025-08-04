-- Insert roles
INSERT INTO ROLE (Name) VALUES 
    ('Admin'), ('Volunteer');

-- Insert volunteers (5 Admins, 15 Regular Volunteers)
INSERT INTO VOLUNTEER (Role_ID, First_name, Last_name, Username, Email, Password, Skill, Location, Availability)
VALUES
-- Admins (Role_ID = 1)
(1, 'Alice', 'Wong', 'alicew', 'alice@example.com', crypt('password1', gen_salt('bf')), ARRAY['First Aid', 'Coordination'], ST_GeogFromText('SRID=4326;POINT(-95.3698 29.7604)'), ARRAY['Mon', 'Tue']),
(1, 'Bob', 'Smith', 'bobsmith', 'bob@example.com', crypt('password2', gen_salt('bf')), ARRAY['Logistics', 'Scheduling'], ST_GeogFromText('SRID=4326;POINT(-95.3584 29.7499)'), ARRAY['Wed', 'Thu']),
(1, 'Clara', 'Nguyen', 'claran', 'clara@example.com', crypt('password3', gen_salt('bf')), ARRAY['Communication', 'Event Planning'], ST_GeogFromText('SRID=4326;POINT(-95.3422 29.7520)'), ARRAY['Fri']),
(1, 'Daniel', 'Lee', 'dlee', 'daniel@example.com', crypt('password4', gen_salt('bf')), ARRAY['Teamwork', 'Tech Support'], ST_GeogFromText('SRID=4326;POINT(-95.4102 29.7619)'), ARRAY['Sat', 'Sun']),
(1, 'Eva', 'Lopez', 'eval', 'eva@example.com', crypt('password5', gen_salt('bf')), ARRAY['Cooking', 'First Aid'], ST_GeogFromText('SRID=4326;POINT(-95.3936 29.7440)'), ARRAY['Mon', 'Wed']),

-- Volunteers (Role_ID = 2)
(2, 'Frank', 'Hill', 'frankh', 'frank@example.com', crypt('password6', gen_salt('bf')), ARRAY['Cleaning', 'Tech Support'], ST_GeogFromText('SRID=4326;POINT(-95.3980 29.7561)'), ARRAY['Tue']),
(2, 'Grace', 'Yu', 'gyu', 'grace@example.com', crypt('password7', gen_salt('bf')), ARRAY['Coordination', 'Logistics'], ST_GeogFromText('SRID=4326;POINT(-95.3822 29.7380)'), ARRAY['Wed']),
(2, 'Henry', 'Zhao', 'hzhao', 'henry@example.com', crypt('password8', gen_salt('bf')), ARRAY['Cooking', 'Driving'], ST_GeogFromText('SRID=4326;POINT(-95.3571 29.7451)'), ARRAY['Thu']),
(2, 'Ivy', 'Tran', 'itran', 'ivy@example.com', crypt('password9', gen_salt('bf')), ARRAY['Translation', 'Child Care'], ST_GeogFromText('SRID=4326;POINT(-95.3702 29.7605)'), ARRAY['Fri']),
(2, 'Jack', 'King', 'jking', 'jack@example.com', crypt('password10', gen_salt('bf')), ARRAY['Tutoring', 'Cleaning'], ST_GeogFromText('SRID=4326;POINT(-95.3665 29.7435)'), ARRAY['Sat']),
(2, 'Kelly', 'Brown', 'kbrown', 'kelly@example.com', crypt('password11', gen_salt('bf')), ARRAY['First Aid', 'Cooking'], ST_GeogFromText('SRID=4326;POINT(-95.3411 29.7490)'), ARRAY['Sun']),
(2, 'Leo', 'Martinez', 'lmart', 'leo@example.com', crypt('password12', gen_salt('bf')), ARRAY['Logistics', 'Tech Support'], ST_GeogFromText('SRID=4326;POINT(-95.3521 29.7650)'), ARRAY['Mon']),
(2, 'Mona', 'Davis', 'mdavis', 'mona@example.com', crypt('password13', gen_salt('bf')), ARRAY['Event Planning', 'Translation'], ST_GeogFromText('SRID=4326;POINT(-95.3911 29.7710)'), ARRAY['Tue']),
(2, 'Nathan', 'Cruz', 'ncruz', 'nathan@example.com', crypt('password14', gen_salt('bf')), ARRAY['Driving', 'Child Care'], ST_GeogFromText('SRID=4326;POINT(-95.3883 29.7425)'), ARRAY['Wed']),
(2, 'Olivia', 'Green', 'ogreen', 'olivia@example.com', crypt('password15', gen_salt('bf')), ARRAY['Tutoring', 'Tech Support'], ST_GeogFromText('SRID=4326;POINT(-95.4022 29.7505)'), ARRAY['Thu']),
(2, 'Peter', 'White', 'pwhite', 'peter@example.com', crypt('password16', gen_salt('bf')), ARRAY['Coordination', 'Logistics'], ST_GeogFromText('SRID=4326;POINT(-95.3680 29.7721)'), ARRAY['Fri']),
(2, 'Quinn', 'Harris', 'qharris', 'quinn@example.com', crypt('password17', gen_salt('bf')), ARRAY['First Aid', 'Child Care'], ST_GeogFromText('SRID=4326;POINT(-95.3860 29.7550)'), ARRAY['Sat']),
(2, 'Rita', 'Young', 'ryoung', 'rita@example.com', crypt('password18', gen_salt('bf')), ARRAY['Translation', 'Tutoring'], ST_GeogFromText('SRID=4326;POINT(-95.3955 29.7590)'), ARRAY['Sun']),
(2, 'Sam', 'Garcia', 'sgarcia', 'sam@example.com', crypt('password19', gen_salt('bf')), ARRAY['Cooking', 'Logistics'], ST_GeogFromText('SRID=4326;POINT(-95.3790 29.7412)'), ARRAY['Mon']),
(2, 'Tina', 'Baker', 'tbaker', 'tina@example.com', crypt('password20', gen_salt('bf')), ARRAY['Driving', 'Event Planning'], ST_GeogFromText('SRID=4326;POINT(-95.3610 29.7485)'), ARRAY['Tue']);

-- Insert events (ensure 1 admin has 4, another has 3, etc.)
INSERT INTO EVENT (Name, Moderator, Location, Description, Priority, Date)
VALUES
('Food Drive', 1, ST_GeogFromText('SRID=4326;POINT(-95.3690 29.7580)'), 'Distribute food to the community.', 5, NOW()),
('Tech Workshop', 1, ST_GeogFromText('SRID=4326;POINT(-95.3589 29.7511)'), 'Tech skills training.', 4, NOW() + interval '1 day'),
('Neighborhood Cleanup', 1, ST_GeogFromText('SRID=4326;POINT(-95.3650 29.7420)'), 'Clean local parks.', 3, NOW() + interval '2 days'),
('First Aid Camp', 1, ST_GeogFromText('SRID=4326;POINT(-95.3750 29.7620)'), 'Train community on first aid.', 4, NOW() + interval '3 days'),

('Cooking for Homeless', 2, ST_GeogFromText('SRID=4326;POINT(-95.3765 29.7499)'), 'Prepare meals.', 5, NOW()),
('Tutoring Drive', 2, ST_GeogFromText('SRID=4326;POINT(-95.3875 29.7603)'), 'Provide tutoring.', 2, NOW() + interval '1 day'),
('Childcare Event', 2, ST_GeogFromText('SRID=4326;POINT(-95.3995 29.7633)'), 'Babysitting during events.', 3, NOW() + interval '2 days'),

('Logistics Training', 3, ST_GeogFromText('SRID=4326;POINT(-95.3730 29.7415)'), 'Train on event logistics.', 4, NOW() + interval '1 day'),
('Translation Booth', 3, ST_GeogFromText('SRID=4326;POINT(-95.3780 29.7465)'), 'Language translation help.', 3, NOW() + interval '3 days'),

('Coordination Meet', 4, ST_GeogFromText('SRID=4326;POINT(-95.3890 29.7444)'), 'Volunteer coordination.', 2, NOW() + interval '4 days');

-- Insert tasks (ensure skill arrays are populated and varied)
INSERT INTO TASK (Event_ID, Name, Skill, Description)
VALUES
(1, 'Pack Food Boxes', ARRAY['Packing', 'Coordination'], 'Organize and pack food.'),
(1, 'Drive Supplies', ARRAY['Driving', 'Logistics'], 'Deliver food to pickup spots.'),
(2, 'Setup Laptops', ARRAY['Tech Support', 'Logistics'], 'Prepare devices for training.'),
(3, 'Clean Park Grounds', ARRAY['Cleaning', 'Teamwork'], 'Trash collection.'),
(4, 'Demonstrate CPR', ARRAY['First Aid', 'Instruction'], 'Show proper CPR techniques.'),
(5, 'Cook Meals', ARRAY['Cooking', 'Hygiene'], 'Prepare and serve meals.'),
(6, 'Tutoring Math', ARRAY['Tutoring', 'Communication'], 'Teach basic math.'),
(7, 'Babysit Toddlers', ARRAY['Child Care', 'Patience'], 'Watch over children.'),
(8, 'Inventory Supplies', ARRAY['Logistics', 'Counting'], 'Track materials.'),
(9, 'Translate Forms', ARRAY['Translation', 'Language'], 'Convert English forms.'),
(10, 'Schedule Shifts', ARRAY['Coordination', 'Scheduling'], 'Manage volunteer times.');

-- Insert volunteer-task assignments
INSERT INTO VOLUNTEER_TASK (Task_ID, Volunteer_ID, Date_accepted)
VALUES
(1, 6, NOW()),
(2, 7, NOW()),
(3, 8, NOW()),
(4, 9, NOW()),
(5, 10, NOW()),
(6, 11, NOW()),
(7, 12, NOW()),
(8, 13, NOW()),
(9, 14, NOW()),
(10, 15, NOW());

-- Insert history of volunteers doing tasks
INSERT INTO VOLUNTEER_HIST (V_task_ID, Start_time, End_time)
VALUES
(1, NOW() - interval '2 hours', NOW() - interval '1 hour'),
(2, NOW() - interval '3 hours', NOW() - interval '2 hours'),
(3, NOW() - interval '4 hours', NOW() - interval '3 hours'),
(4, NOW() - interval '5 hours', NOW() - interval '4 hours'),
(5, NOW() - interval '6 hours', NOW() - interval '5 hours'),
(6, NOW() - interval '2 days', NOW() - interval '2 days' + interval '1 hour'),
(7, NOW() - interval '1 day', NOW() - interval '1 day' + interval '2 hours'),
(8, NOW() - interval '3 days', NOW() - interval '3 days' + interval '1.5 hours'),
(9, NOW() - interval '4 days', NOW() - interval '4 days' + interval '1 hour'),
(10, NOW() - interval '5 days', NOW() - interval '5 days' + interval '3 hours');