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

app.post('/auth/register', async (req, res) => {
    // The register function
    const client = await pool.connect();
    let {username, password} = req.body;
    try {
        await client.query('BEGIN')

        // Checks if username exists already
        const check = await client.query(
            'SELECT * FROM volunteer WHERE username = $1',
            [username]
        );

        // If username found then returns error
        if (check.rows.length > 0) {
            await client.query('ROLLBACK')
            return res.status(409).json({error: 'Username already exists'})
        }
        await client.query(
            // Insert into database
            "INSERT INTO volunteer (username, password) VALUES ($1, $2))",
            [username, password]
        );
        await client.query('COMMIT');
        res.sendStatus(201) //success
    } catch(err){
        await client.query('ROLLBACK');
        console.error(err.message);
        res.sendStatus(500);
    } finally {
        client.release()
    }
})

// http://localhost:8080/eventmatcher
app.get(['/eventMatcher','/eventMatcher.html'], async (req, res) => {
  try {
		const query = 
		`SELECT 
			E.name,
			V.Username AS moderator,
			ST_AsText(E.location) AS location,
			E.description,
			to_char(E.date, 'YYYY-MM-DD HH24:MI:SS') AS date
		FROM 
			EVENT AS E
		LEFT JOIN
			VOLUNTEER AS V
		ON
			E.moderator = V.id;`;
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
