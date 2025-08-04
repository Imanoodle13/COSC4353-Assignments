const express = require('express');
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
const pug = require('pug');
const db = require('./database');
const session = require('express-session');

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

app.get('/', function (req, res) {
	res.render('index')
});

// http://localhost:8080/homepage.html
app.get('/homepage.html', async function (req, res) {
	try {
		let isAdmin = false;
		let isLogged = false;
		if (req.session.user && req.session.user.id && req.session.user.email) {
			isLogged = true;
			const email = req.session.user.email;
			const result = await db.query(
				'SELECT role_id FROM volunteer WHERE email = $1',
				[email]
			);
			isAdmin = result.rows.length > 0 && result.rows[0].role_id === 1;
		}
		res.render('homepage', { isAdmin, isLogged });
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

		// Inserting?
		await db.query(
			'INSERT INTO volunteer (role_id, email, password) VALUES ($1, $2, crypt($3, gen_salt(\'bf\')))',
			[isAdmin, email, password]
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
		const query =
			`
		SELECT 
			E.name,
			V.Username AS moderator,
			ST_AsText(E.location) AS location,
			ARRAY_AGG(DISTINCT s.skill ORDER BY s.skill) AS skills,
			E.description,
			E.priority,
			to_char(E.date, 'YYYY-MM-DD HH24:MI:SS') AS date
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
		`;
		const result = await db.query(query);
		res.render('eventMatcher', { events: result && result.rows ? result.rows : [] });
	} catch (err) {
		console.error('Database query error:', err);
		res.status(500).send('Database connection failed.');
	}

	/*
	let username = 'Guest';
	let u_id = null;
	let events = []
	if (req.session.user) {
		const user = getUsers().find(u => u.email === req.session.user.email);
		if (user) {
			username = user.username;
			u_id = user.ID;
			events = JSON.parse(fs.readFileSync(EVENTS_FILE, 'utf-8')) ?? []
		}
	}
	if (!u_id) {
		return res.redirect('/login.html?error=1');
	}
	res.render('eventMatcher', { username, u_id , events});
	*/
});

// http://localhost:8080/eventcreator
app.get(['/eventCreator', '/eventCreator.html'], function (req, res) {
	let username = 'Guest';
	let u_id = null;
	if (req.session.user) {
		const user = getUsers().find(u => u.email === req.session.user.email);
		if (user) {
			username = user.username;
			u_id = user.ID;
		}
	}
	if (!u_id) {
		return res.redirect('/login.html?error=1');
	}
	res.render('eventCreator', { username, u_id }); // { username, u_id } to remind the user who is currently logged in/moderating the event.
});

app.post('/publishEvent', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		// Get data from body
		const { name, location, description, priority, dateTime } = req.body;
		let events = [];

		if (fs.existsSync(EVENTS_FILE)) {
			const data = fs.readFileSync(EVENTS_FILE, `utf-8`);
			events = data.trim() === ''
				? []
				: JSON.parse(data);
		}

		// Find the user object to get the username
		let moderator = 'Unknown';
		if (req.session.user && req.session.user.email) {
			const users = getUsers();
			const userObj = users.find(u => u.email === req.session.user.email);
			if (userObj && userObj.username) {
				moderator = userObj.username;
			}
		}
		// Create a new event object
		const newEvent = {
			eventId: events.length + 1, // Simple ID generation
			name,
			moderator,
			location,
			description,
			priority: parseInt(priority, 10) || 0,
			date: dateTime,
			tasks: []
		};

		// Add the newEvent to the events array
		events.push(newEvent);
		fs.writeFileSync(EVENTS_FILE, JSON.stringify(events, null, 2), `utf-8`);

		// Convert the newEvent to URL parameters to pass data to task creator
		const params = new URLSearchParams(newEvent).toString();

		res.redirect(`/taskcreator?${params}`);
	} catch (err) {
		console.error('Event creation error:', err);
		res.status(500).send('Server error during publish.');
	}
});

/*
app.post('/publish', express.urlencoded({ extended: true }), async (req, res) => {
	
	try {
		const { name, location, description, priority, dateTime } = req.body;
		let events = [];

		if (fs.existsSync(EVENTS_FILE)) {
			const data = fs.readFileSync(EVENTS_FILE, `utf-8`);
			events = data.trim() === ''
				? []
				: JSON.parse(data);
		}

		const newEvent = {
			name,
			location,
			description,
			priority: parseInt(priority, 10) || 0, // Ensure priority is a number
			date: dateTime
		};

		events.push(newEvent);
		fs.writeFileSync(EVENTS_FILE, JSON.stringify(events, null, 2), `utf-8`);

		const params = new URLSearchParams(newEvent).toString();

		res.redirect(`/taskcreator?${params}`);
	} catch (err) {
		console.error('Event creation error:', err);
		res.status(500).send('Server error during publish.');
	}
});

// http://localhost:8080/taskcreator
app.get(['/taskCreator', '/taskCreator.html'], function (req, res) {
	// Extract event data from query string FIRST
	const { name, location, description, priority, date, eventId } = req.query;
	const listItems = [];

	let username = 'Guest';
	let u_id = null;
	let eventName = '';
	let eventLocation = '';
	let eventDate = '';

	if (req.session.user) {
		const user = getUsers().find(u => u.email === req.session.user.email);
		if (user) {
			username = user.username;
			u_id = user.ID;
		}

		const event = getEvents().find(e => e.eventId === eventId);
		if (event) {
			eventName = event.eventId;
		}
	}
	if (!u_id) {
		return res.redirect('/login.html?error=1');
	}
	res.render('taskCreator', {
		username,
		u_id,
		eventName: name,
		eventId,
		location,
		description,
		priority,
		date,
		listItems
	});
});*/

app.get(['/taskCreator', '/taskCreator.html'], function (req, res) {
	// Extract event data from query string
	const { name, location, description, priority, date, eventId } = req.query;
	let username = 'Guest';
	let u_id = null;
	let tasks = [];

	if (req.session.user) {
		const user = getUsers().find(u => u.email === req.session.user.email);
		if (user) {
			username = user.username;
			u_id = user.ID;
		}
	}

	if (eventId) {
		const events = getEvents();
		const event = events.find(e => e.eventId === parseInt(eventId, 10));
		if (event && Array.isArray(event.tasks)) {
			tasks = event.tasks;
		}
	}

	if (!u_id) {
		return res.redirect('/login.html?error=1');
	}

	res.render('taskCreator', {
		username,
		u_id,
		eventName: name,
		eventId,
		location,
		description,
		priority,
		date,
		tasks
	});
});

app.post('/addTask', express.urlencoded({ extended: true }), (req, res) => {
	try {
		const { eventId, taskName, taskDescription, taskSkills } = req.body;
		const events = getEvents();
		const eventIndex = events.findIndex(e => e.eventId === parseInt(eventId, 10));
		if (eventIndex === -1) {
			return res.status(404).send('Event not found');
		}
		const newTask = {
			taskId: events[eventIndex].tasks.length + 1, // Simple ID generation for tasks
			name: taskName,
			description: taskDescription,
			skills: taskSkills ? taskSkills.split(',').map(skill => skill.trim()) : []
		};
		events[eventIndex].tasks.push(newTask);
		fs.writeFileSync(EVENTS_FILE, JSON.stringify(events, null, 2), 'utf-8');
		res.redirect(`/taskCreator?eventId=${eventId}&name=${encodeURIComponent(events[eventIndex].name)}&location=${encodeURIComponent(events[eventIndex].location)}&description=${encodeURIComponent(events[eventIndex].description)}&priority=${events[eventIndex].priority}&date=${events[eventIndex].date}`);
	} catch (err) {
		console.error('Task addition error:', err);
		res.status(500).send('Server error during task addition.');
	}
});

// http://localhost:8080/eventconfirm
app.get(['/eventconfirm', '/eventconfirm.html'], function (req, res) {
	const { name, location, description, priority, date } = req.query;
	res.render('eventConfirm', { name, location, description, priority, date });
});

app.get(['/userProfile', '/userProfile.html'], function (req, res) {
	if (!req.session.user) {
		return res.redirect('/login.html?error=1');
	}

	const user = getUsers().find(u => u.email === req.session.user.email)

	if (!user) {
		return res.redirect('/login.html?error=1');
	}

	// Passes through the profile information
	res.render('userProfile', { email: req.session.user.email, profile: user.profile || {} });
});

app.post('/complete-profile', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		// If theres no session then redirect to login
		if (!req.session.user) {
			return res.redirect('/login.html?error=1');
		}

		// Get data from body
		const { fullname, address1, address2, city, state, zipcode, skills, preferences, availability } = req.body;
		const users = getUsers();
		const userIndex = users.findIndex(u => u.email === req.session.user.email);

		// Update information at index
		users[userIndex] = {
			...users[userIndex],
			profile: {
				fullname,
				address: {
					address1,
					address2,
					city,
					state,
					zipcode
				},
				skills: Array.isArray(skills) ? skills : [skills], // Array Edge cases
				preferences,
				availability: availability.filter(a => a) // remove empty dates
			}
		};

		fs.writeFileSync(USERS_FILE, JSON.stringify(users, null, 2), 'utf-8')

		res.redirect('/homepage.html');
	} catch (err) {
		console.error('Profile update error:', err);
		res.status(500).send('Server error during profile update.');
	}
});

/*
app.post('/complete-profile', express.urlencoded({ extended: true }), async (req, res) => {
	const client;
	try {
		// If theres no session then redirect to login
		if (!req.session.user) {
			return res.redirect('/login.html?error=1');
		}

		// Get data from body
		const { first_name, last_name, username, address1, address2, city, state, zipcode, skills, preferences, availability } = req.body;
		const address = 
		// Connect to DB
		client = await pool.connect();

		client.query('BEGIN');
		client.query(
			'INSERT INTO volunteer (First_name, Last_name, Username, Skill, Preferences, Availability) VALUES ($1, $2, $3, $4, $5, $6)',
			[first_name, last_name, username, skills, preferences, availability]
		);
		client.query('COMMIT')

		res.redirect('/homepage.html');
	} catch (err) {
		if (client){
			await client.query('ROLLBACK');
		}
		console.error('Profile update error:', err);
		res.status(500).send('Server error during profile update.');
	} finally {
	// Release the client for reuse
		if (client){
			client.release();
		}
	}
});
*/

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

app.get('/notificationSystem', (req, res) => {
	if (!req.session.user) {
		return res.redirect('/login.html');
	}
	const userEmail = req.session.user.email;
	const userNotes = notifications.filter(note => note.email === userEmail);
	res.render('notificationSystem', { notifications: userNotes });
});

app.post('/send-notification', express.urlencoded({ extended: true }), (req, res) => {
	if (!req.session.user) {
		return res.redirect('/login.html');
	}
	const { email, message } = req.body;
	const newNote = { email, message };
	notifications.push(newNote);
	res.redirect('/notificationSystem');
});
