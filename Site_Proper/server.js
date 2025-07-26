const express = require('express');
const fs = require('fs');
const path = require('path');
const pug = require('pug');
const db = require('./database');
const session = require('express-session');

const port = 8080;
const address = '0.0.0.0';
const PORT = process.env.PORT || port;

const app = express();

const USERS_FILE = path.join(__dirname, 'users.json');
const EVENTS_FILE = path.join(__dirname, 'eventInsert.json');

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
app.get('/homepage.html', function (req, res) {
	const isAdmin = req.session.user
		? getUsers().find(u => u.email === req.session.user.email)?.isAdmin
		: false;
	res.render('homepage', { isAdmin });
});

// http://localhost:8080/login.html
app.get(['/login','/login.html'], (req, res) => {
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

app.post(['/login','/login.html'], express.urlencoded({ extended: true }), (req, res) => {
	try {
		const { email, password } = req.body;
		const users = getUsers();
		const user = users.find(u => u.email === email && u.password === password);

		if (user) {
			req.session.user = { email };
			return res.redirect('/homepage.html');
		}

		res.redirect('/login.html?error=1');
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

		// Reads the file and parses into json
		const users = getUsers();

		// If the email is found then error
		if (users.some(u => u.email === email)) {
			return res.redirect('/signup.html?error=1')
		}

		const isAdmin = false;
		if (role == "admin") {
			isAdmin = true;
		}

		users.push({ email, password, isAdmin });
		fs.writeFileSync(USERS_FILE, JSON.stringify(users, null, 2), 'utf-8');
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
			priority;
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
		const { name, location, description, priority, dateTime } = req.body;
		let events = [];

		if (fs.existsSync(EVENTS_FILE)) {
			const data = fs.readFileSync(EVENTS_FILE, `utf-8`);
			events = data.trim() === ''
				? []
				: JSON.parse(data);
		}

		const newEvent = {
			eventId: events.length + 1, // Simple ID generation
			name,
			location,
			description,
			priority: parseInt(priority, 10) || 0,
			date: dateTime,
			tasks: {}
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

app.post('/publish', express.urlencoded({ extended: true }), async (req, res) => {
	try {

	} catch (err) {

	}
	
	/*
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
	}*/
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
	console.log("listening on", serv.address())
});


//notification system
let notifications = [];

app.get('/notificationSystem', (req, res) => {
	if(!req.session.user) {
		return res.redirect('/login.html');
	}

	res.render('notificationSystem', {notifications: notifications});
});

app.post('/send-notification', express.urlencoded({ extended: true }), (req, res) => {
	if (!req.session.user) {
		return res.redirect('/login.html');
	}

	res.redirect('/notificationSystem');
});
