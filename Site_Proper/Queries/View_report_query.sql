CREATE OR REPLACE VIEW reports AS
  WITH
  event_info AS (
    SELECT
      v_hist.id, task.name as task_name, task.event_id, event.name as event_name, event.date, event.location
    FROM volunteer_hist AS v_hist
    JOIN volunteer_task AS v_task ON v_hist.v_task_id = v_task.id
    JOIN task ON v_task.task_id = task.id
    JOIN event ON task.event_id = event.id
  ),
  vol_hist AS (
    SELECT
      v_hist.id, v_task.volunteer_id, vol.first_name, vol.last_name, v_task.task_id, v_task.date_accepted, v_hist.start_time
    FROM volunteer_hist AS v_hist
    JOIN volunteer_task AS v_task ON v_hist.v_task_id = v_task.id
    JOIN volunteer AS vol ON v_task.volunteer_id = vol.id
  )
  SELECT *
  FROM vol_hist
  NATURAL JOIN event_info;