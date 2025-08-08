/* 
Uses the query from:
Queries > sample_report_queries > eventMatcher_orderBySkill.sql
*/
const db = require('./database'); // Access to database.js
const { createObjectCsvWriter: createCsvWriter } = require('csv-writer');

async function generateCSVReport() {
    // Connect to the database
    db.connect();

    // SELECT query for ordering events by skill
    const em_o = await db.query(
        `
        /*
        ORDER BY SKILL:
        This query is used to order the events by relevancy using the logged-in user's skill sets.
        */
        -- Sample ID for Eva Patel: evap (eva@example.com)
        WITH user_skills AS (
            SELECT unnest(Skill) AS skill
            FROM VOLUNTEER
            WHERE ID = 5
        ),
        event_skills AS (
            SELECT 
                E.ID AS event_id,
                E.name,
                V.Username AS moderator,
                E.location,
                E.description,
                E.priority,
                E.date,
                E.Date_published,
                ARRAY_AGG(DISTINCT s.skill ORDER BY s.skill) AS skills,
                COUNT(DISTINCT s.skill) FILTER (WHERE s.skill IN (SELECT skill FROM user_skills)) AS match_count
            FROM 
                EVENT AS E
            LEFT JOIN
                VOLUNTEER AS V ON E.moderator = V.id
            LEFT JOIN
                TASK AS T ON T.Event_ID = E.ID
            LEFT JOIN
                LATERAL unnest(T.Skill) AS s(skill) ON TRUE
            GROUP BY
                E.ID, E.name, V.Username, E.location, E.description, E.priority, E.date, E.Date_published
        )
        SELECT
            event_id AS id,
            name,
            moderator,
            location,
            skills,
            description,
            priority,
            to_char(date, 'Day YYYY-MM-DD') AS date,
            to_char(Date_published, 'Day YYYY-MM-DD HH24:MI:SS') AS published
        FROM
            event_skills
        ORDER BY
            match_count DESC,
            priority DESC,
            date ASC;
        `
    );

    const csvWriter = createCsvWriter({
        path: 'report_eventMatcher_orderBySkill.csv',
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

    // Create CSV writer and write the records as 'report_eventMatcher_orderBySkill.csv'
    await csvWriter.writeRecords(em_o.rows);
    console.log('CSV report generated: report_eventMatcher_orderBySkill.csv');

    // Close and release the database connection
    db.release();
}

generateCSVReport().catch(err => {
    console.error('Error generating CSV report:', err);
    process.exit(1);
});