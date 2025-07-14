const express = require('express');
const fs = require('fs');
const path = require('path');
const pug = require('pug');

const app = express();
app.set('view engine', 'pug');
app.set('views', './views');

app.use(express.static(__dirname));

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

// http://localhost:8080/eventmatcher.html
app.get(['/eventMatcher', '/eventmatcher.html'], (req, res) => {
  res.render('eventMatcher');
});

// http://localhost:8080/eventcreator.html
app.get(['/eventCreator', '/eventCreator.html'], (req,res) => {
	res.render('eventCreator');
});

const serv = app.listen(8080, '0.0.0.0', () => {
	console.log("listening on ", serv.address())
});
