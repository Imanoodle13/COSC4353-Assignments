const express = require('express');
const fs = require('fs');
const path = require('path');
const pug = require('pug');
const db = require('./database');

const port    = 8080;
const address = '0.0.0.0';
const PORT = process.env.PORT || port;

const app = express();

app.set('view engine', 'pug');
app.set('views', path.join(__dirname,'views'));
app.use(express.static(path.join(__dirname,'public')));

app.get('/', function(req, res) {
	res.render('index')
});

// http://localhost:8080/homepage.html
app.get('/homepage.html', function(req, res) {
	res.render('homepage')
});

// http://localhost:8080/login.html
app.get(['/login', '/login.html'], function(req, res) {
	res.render('login');
});

app.get('/signup.html', (req, res) => {
	res.render('signup')
});

app.post('/auth', (req, res) => {
	// The login function
})

app.post('/signup', express.urlencoded({extended: true}), async (req, res) => {
	console.log(req.body)
})

// http://localhost:8080/eventmatcher
app.get(['/eventMatcher','/eventMatcher.html'], async (req, res) => {
  try {
		// Planning on adding functionality to allow user to order table by either:
		// 1. Name
		// 2. Moderator
		// 3. Date
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
		console.error('Database query error:',err);
		res.status(500).send('Database connection failed.');
	}
});

// http://localhost:8080/eventcreator
app.get(['/eventCreator', '/eventCreator.html'], function(req, res) {
	res.render('eventCreator');
});

app.post('/publish', express.urlencoded({extended: true}), async (req, res) => {
	try {
		const { name, moderator, location, description, date } = req.body;
		// Validate fields
		if (!name || !moderator || !location || !description || !date) {
			return alert('An unexpected error occurred.');
		}

		// Parse location input
		let locationPoint;
		if (location.inlcudes(',')){
			const [lat,lang] = location.split(',').map(coord => parseFloat(coord.trim()));
			if (isNaN(lat) || isNaN(lang)) {
				return res.status(400).send('Invalid location format. Use "latitude,longitude".');
			}
			locationPoint = `SRID=4326;POINT(${lang} ${lat})`;
		}else{
			return res.status(400).send('Invalid location format. Use "latitude,longitude".');
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
app.get(['/eventconfirm', '/eventconfirm.html'], function(req, res) {
	res.render('eventConfirm');
});

/* ---------- Test Pages ------------------------*/
// http://localhost:8080/databaseConnectionTest
app.get(['/databaseConnectionTest', '/databaseConnectionTest.html'], async (req,res) => {
	try {
		const result = await db.query('SELECT name,moderator,location FROM EVENT;');
		res.render('databaseConnectionTest', { events: result && result.rows ? result.rows : [] });
	} catch (err) {
		console.error('Database query error:',err);
		res.status(500).send('Database connection failed.');
	}
});

const serv = app.listen(port, address, () => {
	console.log("listening on", serv.address())
});
