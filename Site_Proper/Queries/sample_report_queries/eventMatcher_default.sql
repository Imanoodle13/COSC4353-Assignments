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