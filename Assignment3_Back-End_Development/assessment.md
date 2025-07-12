The following is a sample of the previous project I've worked on with some of the variables replaced to match the context of our project:
# `Server.js` *server-to-database*
## Dependencies
```
const express    = require('express');
const bodyParser = require('body-parser');
const { Pool }   = require('pg');
...
```
## Server Setup
```
const app = express();
...
app.use(express.static(path.join(__dirname, 'Assignment3')));
```
## Database Connection (*PostgreSQL*)
```
const pool = new Pool({
    // Refer to the 📌Pinned channel on Discord
});
```
## Static File Routing
```
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'homepage.html'));
});
app.get('/styles.css', (req,res) => {
res.sendFile(path.join(__dirname, 'styles.css'));
});
```
## General Database Interactions
```
app.post('/admin', async (req, res) => {
    const client = await pool.connect();

    let {Role_ID, First_name, ..., Availability} = req.body;
    
    // Add admin query sample
    try {
        await client.query('BEGIN');
        const adminCheck = 
            await client.query('SELECT * FROM VOLUNTEER WHERE $1;', [Role_ID]);

        await client.query(
            'INSERT INTO VOLUNTEER 
                (Role_ID, First_name, ..., Availability) 
            VALUES ($1, $2, ..., $9)',
            [Role_ID, First_name, ..., Availability]
        );

        await client.query('COMMIT');
        res.sendStatus(201); // Success
    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err.message);
        res.sendStatus(500);
    } finally {
        client.release();
    }
});
```
## Server Start
```
app.listen(3000, () => {
    console.log('Server is running on port 3000!');
});
```
# `FrontendUtils.js` *database-to-UI*
## Various sample functions
```
async function getVolunteer() {
    try {
        const response   = await fetch('/volunteer');
        const volunteers = await response.json();

        const volunteerTable = document.getElementById('volunteerTable);
        volunteerTable.innerHTML = ''; // Clear table before adding new rows

        volunteers.forEach(volunteer => {
            const row = volunteerTable.insertRow();
            row.insertCell(0).textContent = volunteer.Role_ID;
            row.insertCell(1).textContent = volunteer.First_name;
            ...
            row.insertCell(9).textContent = volunteer.Availability;

            if (volunteerTable.rows.length > 100) {
                customerTable.deleteRow(0);
            }
        });
    } catch (error) {
        console.error('Error fetching customers: ', error);
    }
}

async function addVolunteer() {
    const roleID       = document.getElementByID('Role_ID').value;
    const firstName    = document.getElementByID('First_name').value;
    ...
    const availability = document.getElementByID('Availability').value;

    try {
        ...
    } catch (error) {
        console.error('Error adding volunteer:', error);
    }
}

...
```