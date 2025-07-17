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

// Middleware setup
app.use(session({
	secret: 'your_secret_key',
	resave: false,
	saveUninitialized: false,
	cookie: {
		maxAge: 3600000 // Max 1 hour 
	}
}));

const users = [];

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function (req, res) {
	res.render('index')
});

// http://localhost:8080/homepage.html
app.get('/homepage.html', function (req, res) {
	res.render('homepage')
});

// http://localhost:8080/login.html
app.get('/login.html', (req, res) => {
	res.render('login');
});

// http://localhost:8080/signup.html
app.get('/signup.html', (req, res) => {
	res.render('signup')
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

app.post('/login', express.urlencoded({ extended: true }), (req, res) => {
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

app.post('/signup', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		const { email, password } = req.body;

		// Reads the file and parses into json
		const users = getUsers();

		// If the email is found then error
		if (users.some(u => u.email === email)) {
			return res.redirect('/signup.html?error=1')
		}

		users.push({ email, password });
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
			E.ID, E.name, V.Username, E.location, E.description, E.date;
		`;
		const result = await db.query(query);
		res.render('eventMatcher', { events: result && result.rows ? result.rows : [] });
	} catch (err) {
		console.error('Database query error:', err);
		res.status(500).send('Database connection failed.');
	}
});

// http://localhost:8080/eventcreator
app.get(['/eventCreator', '/eventCreator.html'], function (req, res) {
	res.render('eventCreator');
});

app.post('/publish', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		const body = req.body
		const { name, mod, type, loc, desc, date } = Object.values(req.body)
		// Validate fields
		if (!name || !moderator || !location || !description || !date) {
			//return alert('An unexpected error occurred.');
			console.error(name, moderator, loctype, location, description, date)
			console.log(req.body)
			return;
		}

		// Parse location input
		let locationPoint;
		if (type == 'coords') {
			const [lat, lang] = location.split(',').map(coord => parseFloat(coord.trim()));
			if (isNaN(lat) || isNaN(lang)) {
				return res.status(400).send('Invalid location format. Use "latitude,longitude".');
			}
			locationPoint = `SRID=4326;POINT(${lang} ${lat})`;
		} else {
			//return res.status(400).send('Invalid location format. Use "latitude,longitude".');
			//We should have a way of accounting for address formats and converting them to coordinates
		}

		const query = `
			INSERT INTO EVENT (name, moderator, location, description, date) VALUES
			($1, $2, ST_GeogFromText($3), $4, $5, $6)
			RETURNING id;
		`;
		const params = [name, moderator, location, description, date];
		const result = await db.query(query, params);
		const eventId = result.rows[0].id;
		res.redirect(`/eventconfirm?id=${eventId}`);
	} catch (err) {
		console.error('Database insert error:', err);
		res.status(500).send('Failed to create event.');
	}
});

// http://localhost:8080/eventconfirm
app.get(['/eventconfirm', '/eventconfirm.html'], function (req, res) {
	res.render('eventConfirm');
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
