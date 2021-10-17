DROP TABLE IF EXISTS employees;

CREATE TABLE employees(
   id INT GENERATED ALWAYS AS IDENTITY,
   first_name VARCHAR(40) NOT NULL,
   last_name VARCHAR(40) NOT NULL,
   PRIMARY KEY(id)
);

CREATE TABLE employee_audits (
   id INT GENERATED ALWAYS AS IDENTITY,
   employee_id INT NOT NULL,
   last_name VARCHAR(40) NOT NULL,
   changed_on TIMESTAMP(6) NOT NULL
);

CREATE OR REPLACE FUNCTION get(uri character varying)
  RETURNS json AS
$BODY$
import urllib2
 
data = urllib2.urlopen(uri)
 
return data.read()
 
$BODY$
  LANGUAGE plpython2u VOLATILE
  COST 100;
ALTER FUNCTION get(character varying)
  OWNER TO fbernardo;


CREATE OR REPLACE FUNCTION log_last_name_changes()
  RETURNS TRIGGER 
  AS
'
BEGIN
	IF NEW.last_name <> OLD.last_name THEN
		 INSERT INTO employee_audits(employee_id,last_name,changed_on)
		 VALUES(OLD.id,OLD.last_name,now());
	END IF;
   select get("http://localhost:8080?name=Gonzalo")->'hello';
	RETURN NEW;
END;
'
LANGUAGE plpgsql;

CREATE TRIGGER last_name_changes
  BEFORE UPDATE
  ON employees
  FOR EACH ROW
  EXECUTE PROCEDURE log_last_name_changes();