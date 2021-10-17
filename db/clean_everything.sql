DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS employee_audits CASCADE;
DROP FUNCTION IF EXISTS log_last_name_changes;
DROP FUNCTION IF EXISTS send_notify_changes();