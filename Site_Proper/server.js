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

app.get('/login.html', function(req, res) {
	res.render('login')
});

app.get('/signup.html', (req, res) => {
	res.render('signup')
});

app.post('/auth', (req, res) => {
	// The login function
})

// http://localhost:8080/eventmatcher.html
app.get(['/eventMatcher', '/eventmatcher.html'], function(req, res) {
  res.render('eventMatcher');
});

// http://localhost:8080/eventcreator.html
app.get(['/eventCreator', '/eventCreator.html'], function(req, res) {
	res.render('eventCreator');
});

// http://localhost:8080/eventconfirm.html
app.get(['/eventconfirm', '/eventconfirm.html'], function(req, res) {
	res.render('eventConfirm');
});

/* ---------- Test Pages ------------------------*/
// http://localhost:8080/databaseConnectionTest.html
app.get('/database-test', async (req,res) => {
	try {
		const result = await db.query('SELECT NOW();');
		res.render('databaseConnectionTest', {time: result.rows[0].now});
	} catch (err) {
		console.error('Database query error:',err);
		res.status(500).send('Database connection failed.');
	}
});

const serv = app.listen(port, address, () => {
	console.log("listening on", serv.address())
});
