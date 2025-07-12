// Import
/*
We start by importing Express which is the web 
server framework we are using. 
The express() function is a top-level function 
exported by the express module.
*/
const express = require('express');

const app     = express();

// Server address setup
/*
Set up the website to run on port 7000. 
    (Change 7000 is in use on your machine.)
You can start the web server by running:
node server.js from the root of your project folder.
You can open http://localhost:7000 in your browser.
*/
const server = app.listen(7000, () => {
    console.log(`Express running on PORT ${server.address().port}`);
});


// Sample GET request
/*
The code above specifies that when a GET request 
is made to the root of our website, the callback 
function we specified within the get() method 
will be invoked. 
In this case, we are sending the text “Hello World!” back to the browser.
*/
app.get('/', (req,res) => {
    res.send('Hello World!');
});

/**ERROR:  Error: Cannot find module 'express'*/