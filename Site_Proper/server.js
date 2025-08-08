const express = require('express');
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
const pug = require('pug');
const db = require('./database');
const session = require('express-session');
const jq = require('jquery');
const poll = require('poll');
const querystring = require('querystring')
const pdfkit = require('pdfkit')
const bs = require('blob-stream')
const arrays = require('@thi.ng/arrays')

const port = 8080;
const address = '0.0.0.0';
const PORT = process.env.PORT || port;

const app = express();
exports.app = app;

const USERS_FILE = path.join(__dirname, 'users.json');
const EVENTS_FILE = path.join(__dirname, 'eventInsert.json');

module.exports

// Middleware setup
app.use(session({
	secret: 'your_secret_key',
	resave: false,
	saveUninitialized: false,
	cookie: {
		maxAge: 3600000 // Max 1 hour 
	}
}));

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res) {
	res.render('index')
});

// http://localhost:8080/homepage.html
app.get('/homepage.html', async function(req, res) {
	try {
		let isAdmin = false;
		let isLogged = false;
		let user_name = 'Guest';
		if (req.session.user && req.session.user.id && req.session.user.email) {
			isLogged = true;
			const email = req.session.user.email;
			const result = await db.query(
				'SELECT role_id, username FROM volunteer WHERE email = $1',
				[email]
			);
			isAdmin = result.rows.length > 0 && result.rows[0].role_id === 1;
			user_name = result.rows.length > 0 ? result.rows[0].username : 'Guest';
		}
		res.render('homepage', { isAdmin, isLogged, user_name });
	} catch (err) {
		console.error('Homepage error:', err);
		res.status(500).send('Server error');
	}
});

// http://localhost:8080/login.html
app.get(['/login', '/login.html'], (req, res) => {
	res.render('login');
});

// http://localhost:8080/signup.html
app.get('/signup.html', (req, res) => {
	res.render('signup');
});

function getUsers() {
	try {
		// If the file is empty it will return empty array
		if (!fs.existsSync(USERS_FILE)) {
			fs.writeFileSync(USERS_FILE, '[]', 'utf-8');
			return [];
		}

		const data = fs.readFileSync(USERS_FILE, 'utf-8');
		// If its empty then it returns empty array otherwise returns JSON
		return data.trim() === '' ? [] : JSON.parse(data);
	} catch {
		console.error('Retrieving User error:', err);
		throw err;
	}
}

function getEvents() {
	try {
		if (!fs.existsSync(EVENTS_FILE)) {
			fs.writeFileSync(EVENTS_FILE, '[]', 'utf-8');
			return [];
		}

		const data = fs.readFileSync(EVENTS_FILE, 'utf-8');
		return data.trim() === '' ? [] : JSON.parse(data);
	} catch {
		console.error('Retrieving Event error:', err);
		throw err;
	}
}

app.post(['/login', '/login.html'], express.urlencoded({ extended: true }), async (req, res) => {
	try {
		const { email, password } = req.body;
		const result = await db.query(
			'SELECT id, email FROM volunteer WHERE email = $1 AND password = crypt($2, password)',
			[email, password]
		);

		if (result.rows.length === 0) {
			return res.redirect('/login.html?error=1');
		}

		const user = result.rows[0];

		if (user) {
			req.session.user = {
				id: user.id,
				email: user.email
			};
		}
		await req.session.save();

		return res.redirect('/homepage.html');
	} catch (err) {
		console.error('Log In error:', err);
		res.status(500).send('Server error during Log In');
	}
});


app.get('/logout', (req, res) => {
	// if the session doesnt exist then redirect to login
	if (!req.session.user) {
		return res.redirect('/login.html?error=2');
	}
	// Destroy session
	req.session.destroy(err => {
		if (err) console.error('Session destruction error:', err);

		res.clearCookie('connect.sid', {
			path: '/',
			httpOnly: true,
			secure: process.env.NODE_ENV === 'production'
		});

		res.redirect('/login.html');
	});
});

app.post('/signup', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		const { email, password, role } = req.body;

		// Email Validation
		if (!email.includes('@') || !(email.indexOf('@') > 0) || !email.includes('.') || !(email.indexOf(".") < email.length - 1)) {
			return res.status(400).send("Enter a valid email");
		}

		// Password validations
		if (password.length < 8) {
			return res.status(400).send("Password must be at least 8 characters long");
		}
		if (!/[A-Z]/.test(password)) {
			return res.status(400).send("Password must include at least 1 capital letter");
		}
		if (!/[a-z]/.test(password)) {
			return res.status(400).send("Password must include at least 1 lowercase letter");
		}
		if (!/\d/.test(password)) {
			return res.status(400).send("Password must include at least 1 number");
		}
		if (!/[!@#$%^&*]/.test(password)) {
			return res.status(400).send("Password must include at least 1 special character");
		}

		// Check if it exists
		const result = await db.query(
			'SELECT FROM volunteer WHERE email = $1',
			[email]
		);

		// If the email is found then error
		if (result.rows.length > 0) {
			return res.redirect('/signup.html?error=1')
		}

		// If role is admin then set isAdmin to 1 otherwise set to 2
		const isAdmin = role === "Admin" ? 1 : 2;
		const dateEnrolled = new Date().toISOString();

		// Inserting?
		await db.transact(
			'INSERT INTO volunteer (role_id, email, password, date_enrolled) VALUES ($1, $2, crypt($3, gen_salt(\'bf\')), $4)',
			[isAdmin, email, password, dateEnrolled]
		);
		res.redirect('/login.html?success=1')
	} catch (err) {
		console.error('Register error:', err);
		res.status(500).send('Server error during registration');
	}
});

// http://localhost:8080/eventmatcher
app.get(['/eventMatcher', '/eventMatcher.html'], async (req, res) => {
	try {
		let userId = null;
		let skillArr = 'None';

		// If the user is logged in, get their ID
		if (req.session.user && req.session.user.email) {
			const userResult = await db.query(
				'SELECT id,skill FROM volunteer WHERE email = $1',
				[req.session.user.email]
			);
			if (userResult.rows.length > 0) {
				userId = userResult.rows[0].id;
				skillArr = userResult.rows[0].skill ? userResult.rows[0].skill.join(', ') : 'None';
			}
		}

		let result;

		// If "Order by skill" is selected and user is logged in,
		if (req.query.orderby === 'skill' && userId !== null) {
			result = await db.query(`
				WITH user_skills AS (
					SELECT unnest(Skill) AS skill
					FROM VOLUNTEER
					WHERE ID = $1
				),
				event_skills AS (
					SELECT 
						E.ID AS event_id,
						E.name,
						V.Username AS moderator,
						E.location,
						E.description,
						E.priority,
						E.date,
						E.Date_published,
						ARRAY_AGG(DISTINCT s.skill ORDER BY s.skill) AS skills,
						COUNT(DISTINCT s.skill) FILTER (WHERE s.skill IN (SELECT skill FROM user_skills)) AS match_count
					FROM 
						EVENT AS E
					LEFT JOIN
						VOLUNTEER AS V ON E.moderator = V.id
					LEFT JOIN
						TASK AS T ON T.Event_ID = E.ID
					LEFT JOIN
						LATERAL unnest(T.Skill) AS s(skill) ON TRUE
					GROUP BY
						E.ID, E.name, V.Username, E.location, E.description, E.priority, E.date, E.Date_published
				)
				SELECT
					event_id AS id,
					name,
					moderator,
					location,
					skills,
					description,
					priority,
					to_char(date, 'Day YYYY-MM-DD') AS date,
					to_char(Date_published, 'Day YYYY-MM-DD HH24:MI:SS') AS published
				FROM
					event_skills
				ORDER BY
					match_count DESC,
					priority DESC,
					date ASC;
			`, [userId]);
		} else {
			// Default: Order by priority
			result = await db.query(`
				SELECT 
					E.id,
					E.name,
					V.Username AS moderator,
					E.location,
					ARRAY_AGG(DISTINCT s.skill ORDER BY s.skill) AS skills,
					E.description,
					E.priority,
					to_char(E.date, 'Day YYYY-MM-DD') AS date,
					to_char(E.Date_published, 'Day YYYY-MM-DD HH24:MI:SS') AS published
				FROM 
					EVENT AS E
				LEFT JOIN
					VOLUNTEER AS V ON E.moderator = V.id
				LEFT JOIN
					TASK AS T ON T.Event_ID = E.ID
				LEFT JOIN
					LATERAL unnest(T.Skill) AS s(skill) ON TRUE
				GROUP BY
					E.ID, E.name, V.Username, E.location, E.description, E.date
				ORDER BY
					priority DESC;
			`);
		}

		res.render('eventMatcher', {
			events: result && result.rows ? result.rows : [],
			orderbySkill: req.query.orderby === 'skill',
			userSkill: skillArr
		});
	} catch (err) {
		console.error('Database query error:', err);
		res.status(500).send('Database connection failed.');
	}
});


// http://localhost:8080/eventDetails
// Pug implement pending
app.get('/eventDetails/:id', async (req, res) => {
	const eventId = req.params.id;
	console.log("Fetching event with ID:", eventId);
	try {
		const eventDetails = await db.query(
			`
			SELECT 
				E.id,
				E.name,
				V.Username AS moderator,
				E.location,
				ARRAY_AGG(DISTINCT s.skill ORDER BY s.skill) AS skills,
				E.description,
				E.priority,
				to_char(E.date, 'Day YYYY-MM-DD') AS date,
				to_char(E.Date_published, 'Day YYYY-MM-DD HH24:MI:SS') AS published
			FROM 
				EVENT AS E
			LEFT JOIN
				VOLUNTEER AS V ON E.moderator = V.id
			LEFT JOIN
				TASK AS T ON T.Event_ID = E.ID
			LEFT JOIN
				LATERAL unnest(T.Skill) AS s(skill) ON TRUE
			WHERE E.id = $1
			GROUP BY
				E.ID, E.name, V.Username, E.location, E.description, E.date;
			`, [eventId]);
		if (eventDetails.rows.length === 0) {
			return res.status(404).send('Event not found');
		}
		const userDetails = await db.query(
			'SELECT id, username, email, availability FROM volunteer WHERE email = $1',
			[req.session.user.email]
		);
		const taskDetails = await db.query(
			`
			SELECT
				id,
				name,
				skill,
				description
			FROM task WHERE event_id = $1;
			`, [eventId]);

		res.render('eventDetails', {
			event: eventDetails.rows[0],
			user: userDetails.rows[0] || {},
			task: taskDetails.rows || []
		});
	} catch (err) {
		console.error(err);
		res.status(500).send('Server error');
	}
});

app.post('/enrollTask', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		if (!req.session.user) {
			return res.redirect('/login.html?error=2');
		}

		const { taskId } = req.body;

		// Get current user ID from session
		const userRes = await db.query(
			'SELECT id FROM volunteer WHERE email = $1',
			[req.session.user.email]
		);

		if (userRes.rows.length === 0) {
			return res.status(400).send('User not found');
		}

		const volunteerId = userRes.rows[0].id;

		// Check if volunteer is already enrolled in this task
		const exists = await db.query(
			'SELECT id FROM volunteer_task WHERE task_id = $1 AND volunteer_id = $2',
			[taskId, volunteerId]
		);



		if (exists.rows.length > 0) {
			return res.redirect(`/taskEnrollConfirm/${taskId}?error=already_enrolled`);
		}

		// Insert into VOLUNTEER_TASK and get the new record ID
		const insertResult = await db.transact(
			`INSERT INTO volunteer_task (task_id, volunteer_id, date_accepted)
			 VALUES ($1, $2, NOW()) RETURNING id`,
			[taskId, volunteerId]
		);

		const volTaskId = insertResult.rows[0].id;

		// Insert into VOLUNTEER_HIST using the correct volunteer_task ID
		await db.transact(
			`INSERT INTO volunteer_hist (V_task_ID, Start_time, End_Time) 
			 VALUES ($1, NOW(), NULL)`,
			[volTaskId]
		);

		res.redirect(`/taskEnrollConfirm/${taskId}?success=1&volTaskId=${volTaskId}`);
	} catch (err) {
		console.error('Task enrollment error:', err);
		res.status(500).send('Server error during task enrollment.');
	}
});

// http://localhost:8080/taskEnrollConfirm/:taskId
app.get('/taskEnrollConfirm/:taskId', async (req, res) => {
	const taskId = req.params.taskId;
	try {
		const taskId = req.params.taskId;
		const volTaskId = req.query.volTaskId;

		const volTaskDetails = await db.query(
			`
			SELECT
				V.username AS enrollee,
				T.name AS task_name,
				E.name AS event_name
			FROM volunteer_task AS VT
			LEFT JOIN task AS T ON VT.task_id = T.id
			LEFT JOIN event AS E ON T.event_id = E.id
			LEFT JOIN volunteer AS V ON VT.volunteer_id = V.id
			WHERE VT.id = $1;
			`,
			[volTaskId]
		);
		if (volTaskDetails.rows.length === 0) {
			return res.status(404).send('Task enrollment not found');
		}

		res.render('taskEnrollConfirm', {
			volTask: volTaskDetails.rows[0]
		});
	} catch (err) {
		console.error('Task enrollment confirmation error:', err);
		res.status(500).send('Server error during task enrollment confirmation.');
	}
});

// http://localhost:8080/eventcreator
app.get(['/eventCreator', '/eventCreator.html'], async (req, res) => {
	let username = 'Guest';
	let u_id = null;
	// Using the SQL database to get the user information
	const user = await db.query(
		'SELECT id, username FROM volunteer WHERE email = $1',
		[req.session.user.email]
	);
	if (user.rows.length > 0) {
		username = user.rows[0].username || 'Guest';
		u_id = user.rows[0].id;
	} else {
		return res.redirect('/login.html?error=1');
	}
	res.render('eventCreator', { username, u_id }); // { username, u_id } to remind the user who is currently logged in/moderating the event.
});

app.post('/publishEvent', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		const { name, location, description, priority, dateTime } = req.body;

		// Get the volunteer ID
		const volResult = await db.query(
			`SELECT id FROM volunteer WHERE email = $1;`,
			[req.session.user.email]
		);

		if (volResult.rows.length === 0) {
			return res.status(400).send('User not found');
		}

		const vol_id = volResult.rows[0].id;

		// Convert dateTime to ISO for PostgreSQL
		const date = new Date(dateTime).toISOString();
		const publishedDate = new Date().toISOString();

		// Insert new event and get numeric event_id
		const eventInsertResult = await db.transact(
			`INSERT INTO event 
				(name, moderator, location, description, priority, date, date_published) 
			 VALUES ($1, $2, $3, $4, $5, $6, $7) 
			 RETURNING id;`,
			[name, vol_id, location, description, priority, date, publishedDate]
		);

		const event_id = eventInsertResult.rows[0].id; // ✅ Extract the number

		// Build query string for redirect
		const eventDetails = {
			eventId: event_id,
			eventName: name,
			location,
			description,
			priority,
			date
		};

		res.redirect('/taskCreator?' + querystring.stringify(eventDetails));
	} catch (err) {
		console.error('Event creation error:', err);
		res.status(500).send('Server error during publish.');
	}
});


app.get(['/taskCreator', '/taskCreator.html'], async (req, res) => {
	try {
		const { eventId } = req.query;
		let tasks = [];

		// Ensure we have an eventId
		if (!eventId) {
			return res.status(400).send('Missing eventId');
		}

		// Get user info from DB
		const vol_info_result = await db.query(
			`SELECT id, username FROM volunteer WHERE email = $1;`,
			[req.session.user.email]
		);

		if (vol_info_result.rows.length === 0) {
			return res.redirect('/login.html?error=1');
		}

		const vol_info = vol_info_result.rows[0];

		// Get event details from DB
		const eventResult = await db.query(
			`SELECT id, name, location, description, priority, date 
			 FROM event WHERE id = $1;`,
			[eventId]
		);

		if (eventResult.rows.length === 0) {
			return res.status(404).send('Event not found');
		}

		const eventData = eventResult.rows[0];

		// Get tasks for this event
		const taskResult = await db.query(
			`SELECT id, name, description, skill 
			 FROM task WHERE event_id = $1;`,
			[eventId]
		);
		tasks = taskResult.rows;

		// Render page with DB-verified data
		res.render('taskCreator', {
			username: vol_info.username,
			u_id: vol_info.id,
			eventName: eventData.name,
			eventId: eventData.id,
			location: eventData.location,
			description: eventData.description,
			priority: eventData.priority,
			date: eventData.date,
			tasks: tasks
		});

	} catch (err) {
		console.error('Task creator error:', err);
		res.status(500).send('Server error loading task creator.');
	}
});

app.post('/addTask', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		const { eventId, taskName, taskDescription, skills } = req.body; // Changed from 'taskSkills' to 'skills'

		// Convert skills array or null (skills comes as an array from checkboxes)
		let skillsArray = null;
		if (skills && Array.isArray(skills) && skills.length > 0) {
			skillsArray = skills;
		}

		await db.transact(
			`INSERT INTO task (event_id, name, skill, description)
			 VALUES ($1, $2, $3, $4);`,
			[eventId, taskName, skillsArray, taskDescription]
		);

		const eventRes = await db.query(
			`SELECT id, name, location, description, priority, date
			 FROM event WHERE id = $1;`,
			[eventId]
		);

		if (eventRes.rows.length === 0) {
			return res.status(404).send('Event not found');
		}

		const e = eventRes.rows[0];

		res.redirect('/taskCreator?' + querystring.stringify({
			eventId: e.id,
			eventName: e.name,
			location: e.location,
			description: e.description,
			priority: e.priority,
			date: e.date
		}));
	} catch (err) {
		console.error('Task addition error:', err);
		res.status(500).send('Server error during task addition.');
	}
});

app.get('/userReport', async (req, res) => {


	let vol_id = []

	db.query(
		`SELECT volunteer_id FROM reports`, []).then(
			returned => {
				vol_id = returned.rows
				for (let i in returned.rows) {
					vol_id.push(returned.rows[i].volunteer_id)
				}
			},
			error => console.log(error.message)
		)

	let vol_info = []


})
app.post('/deleteTask', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		const { taskId, eventId } = req.body;

		// Delete the task (PostgreSQL will cascade delete any volunteer-task relations)
		await db.transact(`DELETE FROM task WHERE id = $1;`, [taskId]);

		// Get event details for redirect
		const eventRes = await db.query(
			`SELECT id, name, location, description, priority, date
			FROM event WHERE id = $1;`,
			[eventId]
		);

		if (eventRes.rows.length === 0) {
			return res.status(404).send('Event not found');
		}

		const e = eventRes.rows[0];

		res.redirect('/taskCreator?' + querystring.stringify({
			eventId: e.id,
			eventName: e.name,
			location: e.location,
			description: e.description,
			priority: e.priority,
			date: e.date
		}));
	} catch (err) {
		console.error('Task deletion error:', err);
		res.status(500).send('Server error during task deletion.');
	}
});


// http://localhost:8080/eventconfirm
app.get(['/eventconfirm', '/eventconfirm.html'], function(req, res) {
	const { name, location, description, priority, date } = req.query;
	res.render('eventConfirm', { name, location, description, priority, date });
});

app.get(['/userProfile', '/userProfile.html'], async function(req, res) {

	// Query to retrieve all data
	const result = await db.query(
		'SELECT first_name, last_name, username, skill, location, availability FROM volunteer WHERE email = $1',
		[req.session.user.email]
	);

	const userData = result.rows[0] || {};

	// Separate by comma
	const locationString = userData?.location ?? '';
	const parts = locationString.split(',').map(part => part.trim());

	const address = parts[0] ?? '';
	const city = parts[1] ?? '';
	const [state, zipcode] = (parts[2] ?? '').split(' ');


	res.render('userProfile', {
		email: req.session.user.email,
		firstname: userData.first_name || "",
		lastname: userData.last_name || "",
		username: userData.username || "",
		address: address || "",
		city: city || "",
		state: state || "",
		zipcode: zipcode || "",
		skills: userData.skills || [],
		availability: userData.availability || []
	});
});
/*
app.get(['/userProfile', '/userProfile.html'], async function (req, res) {

	// Query to retrieve all data
	const result = await db.query(
		'SELECT first_name, last_name, username, skill, location, availability FROM volunteer WHERE email = $1',
		[email]
	);

	const userData = result.rows[0] || {};

	res.render('userProfile', {
		email: req.session.user.email,
		firstname: userData.first_name || "",
		lastname: userData.last_name || "",
		username: userData.username || "",
		skills: userData.skills || [],
		availability: userData.availability || []
	});
});
*/

/*
app.post('/complete-profile', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		console.log(req.body);
		// Get data from body
		const { fullname, address1, address2, city, state, zipcode, skills, preferences, availability } = req.body;



		res.redirect('/homepage.html');
	} catch (err) {
		console.error('Profile update error:', err);
		res.status(500).send('Server error during profile update.');
	}
});
*/

app.post('/complete-profile', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		// Get data from body
		const { firstname, lastname, username, address, city, state, zipcode, skills, availability } = req.body;
		const fullAddress = `${address}, ${city}, ${state} ${zipcode}`;
		console.log(fullAddress);
		await db.transact(
			'UPDATE volunteer SET first_name = $1, last_name = $2, username = $3, location = $4, skill = $5::text[], availability = $6::text[] WHERE email = $7',
			[firstname, lastname, username, fullAddress, skills, availability, req.session.user.email]
		);

		res.redirect('/homepage.html');
	} catch (err) {
		console.error('Profile update error:', err);
		res.status(500).send('Server error during profile update.');
	}
});


/* ---------- Test Pages ------------------------*/
// http://localhost:8080/databaseConnectionTest
app.get(['/databaseConnectionTest', '/databaseConnectionTest.html'], async (req, res) => {
	try {
		const result = await db.query('SELECT name,moderator,location FROM EVENT;');
		res.render('databaseConnectionTest', { events: result && result.rows ? result.rows : [] });
	} catch (err) {
		console.error('Database query error:', err);
		res.status(500).send('Database connection failed.');
	}
});

const serv = app.listen(port, address, () => {
	const addr = serv.address();
	if (addr && typeof addr === 'object') {
		console.log(`listening on http://${addr.address}:${addr.port}`);
	} else {
		console.log(`listening on port ${port}`);
	}
});

//notification system
let notifications = [];

app.get('/notificationSystem', async (req, res) => {
	if (!req.session.user) {
		return res.redirect('/login.html');
	}
	try {
		const userEmail = req.session.user.email;
		const result = await db.query(
			'SELECT message FROM notification WHERE email = $1',
			[userEmail]
		);
		res.render('notificationSystem', { notifications: result.rows });
	} catch (err) {
		console.error('Notification Error:', err);
		res.status(500).send('Notification Error.');
	}
});

app.post('/send-notification', express.urlencoded({ extended: true }), async (req, res) => {
	if (!req.session.user) {
		return res.redirect('/login.html');
	}
	try {
		const check = await db.query(
			'SELECT role_id FROM volunteer WHERE email = $1',
			[req.session.user.email]
		);
		if (check.rows[0].role_id !== 1) {
			return res.status(403).send('Admins only');
		}
		const { email, message } = req.body;
		await db.transact(
			'INSERT INTO notification (email, message) VALUES ($1, $2)',
			[email, message]
		);
		res.redirect('/notificationSystem');
	} catch (err) {
		console.error('Notification Error:', err);
		res.status(500).send('Notification Error.');
	}
});
