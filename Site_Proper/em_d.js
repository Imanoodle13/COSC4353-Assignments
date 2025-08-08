/* 
Uses the query from:
Queries > sample_report_queries > eventMatcher_default.sql
*/
const db = require('./database'); // Access to database.js
const { createObjectCsvWriter: createCsvWriter } = require('csv-writer');

async function generateCSVReport() {
    // Connect to the database
    db.connect();

    // SELECT query for default event matcher
    const em_d = await db.query(
        `
        /*
        DEFAULT:
        Selection of events for working with the eventMatcher.pug image.
        */
        SELECT 
            E.id,
            E.name,
            V.Username AS moderator,
            E.location,
            ARRAY_AGG(DISTINCT s.skill ORDER BY s.skill) AS skills,
            E.description,
            E.priority,
            to_char(E.date, 'Day YYYY-MM-DD') AS date,
            to_char(E.Date_published, 'Day YYYY-MM-DD HH24:MI:SS') AS published
        FROM 
            EVENT AS E
        LEFT JOIN
            VOLUNTEER AS V ON E.moderator = V.id
        LEFT JOIN
            TASK AS T ON T.Event_ID = E.ID
        LEFT JOIN
            LATERAL unnest(T.Skill) AS s(skill) ON TRUE
        GROUP BY
            E.ID, E.name, V.Username, E.location, E.description, E.date
        ORDER BY
            priority DESC;
        `
    );

    // Create CSV writer and write the records as 'report_eventMatcher_default.csv'
    const csvWriter = createCsvWriter({
        path: 'report_eventMatcher_default.csv',
        header: [
            {id: 'id', title: 'ID'},
            {id: 'name',        title: 'Name'},
            {id: 'moderator',   title: 'Moderator'},
            {id: 'location',    title: 'Location'},
            {id: 'skills',      title: 'Skills'},
            {id: 'description', title: 'Description'},
            {id: 'priority',    title: 'Priority'},
            {id: 'date',        title: 'Date'},
            {id: 'published',   title: 'Published'}
        ]
    });

    // Create CSV writer and write the records as 'report_eventMatcher_default.csv'
    await csvWriter.writeRecords(em_d.rows);
    console.log('CSV report generated: report_eventMatcher_default.csv');

    // Close and release the database connection
    db.release();
}

generateCSVReport().catch(err => {
    console.error('Error generating CSV report:', err);
    process.exit(1);
});