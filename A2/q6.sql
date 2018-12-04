-- Steady work

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q6;

-- You must not change this table definition.
CREATE TABLE q6 (
	group_id integer,
	first_file varchar(25),
	first_time timestamp,
	first_submitter varchar(25),
	last_file varchar(25),
	last_time timestamp,
	last_submitter varchar(25),
	elapsed_time interval
);

-- all groups decleared in A1
DROP VIEW IF EXISTS a1_submission CASCADE;
CREATE VIEW a1_submission AS
SELECT * FROM Submissions
WHERE group_id IN (SELECT DISTINCT group_id
FROM Assignment NATURAL JOIN AssignmentGroup
WHERE description='A1');

-- each group's first and last submission date
DROP VIEW IF EXISTS a1_time CASCADE;
CREATE VIEW a1_time AS
SELECT group_id,min(submission_date) AS first_time, max(submission_date) AS last_time
FROM a1_submission
GROUP BY group_id;

DROP VIEW IF EXISTS a1_min_sub CASCADE;
CREATE VIEW a1_min_sub AS
SELECT DISTINCT S1.group_id,S1.submission_id AS min from a1_submission S1,a1_submission S2
where S1.group_id=S2.group_id
AND S1.submission_date <=
ALL(SELECT submission_date FROM a1_submission WHERE group_id=S1.group_id);

DROP VIEW IF EXISTS a1_max_sub CASCADE;
CREATE VIEW a1_max_sub AS
SELECT DISTINCT S1.group_id,S1.submission_id AS max from a1_submission S1,a1_submission S2
where S1.group_id=S2.group_id
AND S1.submission_date >=
ALL(SELECT submission_date FROM a1_submission WHERE group_id=S1.group_id);

DROP VIEW IF EXISTS a1_min_max CASCADE;
CREATE VIEW a1_min_max AS
SELECT * FROM a1_min_sub NATURAL JOIN a1_max_sub;

-- select file_name, time, submitter from min and max of each group
DROP VIEW IF EXISTS a1_min_info CASCADE;
CREATE VIEW a1_min_info AS
select group_id,file_name AS first_file, submission_date AS first_time, username AS first_submitter
from a1_submission
where submission_id in (
	select min from a1_min_sub
);

DROP VIEW IF EXISTS a1_max_info CASCADE;
CREATE VIEW a1_max_info AS
select group_id, file_name AS last_file, submission_date AS last_time, username AS last_submitter
from a1_submission
where submission_id in (select max from a1_max_sub);

DROP VIEW IF EXISTS ans CASCADE;
CREATE VIEW ans AS
select *, last_time-first_time AS elapsed_time
from a1_min_info NATURAL FULL OUTER JOIN a1_max_info;

-- Final answer.
INSERT INTO q6
SELECT * from ans;
	-- put a final query here so that its results will go into the table.
