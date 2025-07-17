const express = require('express');
const fs = require('fs');
const path = require('path');
const pug = require('pug');
const db = require('./database');
const session = require('express-session')

const port = 8080;
const address = '0.0.0.0';
const PORT = process.env.PORT || port;

const app = express();

// Middleware setup
app.use(session({
	secret: 'your_secret_key',
	resave: false,
	saveUninitialized: false,
	cookie: {
		maxAge: 3600000 // Max 1 hour 
	}
}))

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

app.post('/login', express.urlencoded({ extended: true }), (req, res) => {
	try {
		const { email, password } = req.body;
		res.redirect('/homepage.html');
		/*if (user) {
			res.session.user = { email };
			res.redirect('/homepage.html');
		}
		else {
			console.log('User not found in Users array');
			res.redirect('/homepage.html');
		}*/
	} catch (err) {
		console.error('Register error:', err);
		res.status(500).send('Server error during registration');
	}
});

app.post('/signup', express.urlencoded({ extended: true }), async (req, res) => {
	try {
		const { email, password } = req.body;
		users.push({ email, password });
		console.log(users);
	} catch (err) {
		console.error('Register error:', err);
		res.status(500).send('Server error during registration')
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
