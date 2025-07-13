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

app.get('/homepage.html', function(req, res) {
	res.render('homepage')
});

app.get(['/eventMatcher', '/eventmatcher.html'], (req, res) => {
  res.render('eventMatcher');
});

app.listen(8080, () => {
	console.log("listening at 8080...")
});
