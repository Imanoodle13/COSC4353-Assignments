const express = require('express');
const fs = require('fs');
const path = require('path');
const pug = require('pug');

const app = express();
app.set('view engine', 'pug')
app.set('views', './views')

app.use(express.static(__dirname))

app.get('/', function(req, res) {
	res.render('index')
});

app.get('/homepage.html', function(req, res) {
	res.render('homepage')
});


const serv = app.listen(8080, '0.0.0.0', () => {
	console.log("listening on ", serv.address())
});
