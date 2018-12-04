-- A1 report

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q10;

-- You must not change this table definition.
CREATE TABLE q10 (
	group_id integer,
	mark real,
	compared_to_average real,
	status varchar(5)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
-- DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- FROM Grade NATURAL JOIN AssignmentGroup NATURAL JOIN Assignment
-- WHERE description='A1';

DROP VIEW IF EXISTS total_mark CASCADE;
CREATE VIEW total_mark AS
SELECT sum(out_of*weight) AS total
FROM RubricItem NATURAL JOIN Assignment
WHERE description='A1';

DROP VIEW IF EXISTS avg CASCADE;
CREATE VIEW avg AS
SELECT avg(mark)/(SELECT total from total_mark)*100 AS avg
FROM Result,total_mark;

DROP VIEW IF EXISTS group_mark CASCADE;
CREATE VIEW group_mark AS
SELECT group_id,mark/total*100 AS mark
FROM Result,total_mark;

DROP VIEW IF EXISTS all_groups CASCADE;
CREATE VIEW all_groups AS
SELECT group_id
FROM AssignmentGroup;

DROP VIEW IF EXISTS above_avg CASCADE;
CREATE VIEW above_avg AS
SELECT group_id, mark, mark-avg AS compared_to_average, varchar(5) 'above' AS status
FROM avg,group_mark
WHERE mark>avg;
SELECT * from above_avg;

DROP VIEW IF EXISTS at_avg CASCADE;
CREATE VIEW at_avg AS
SELECT group_id, mark, mark-avg AS compared_to_average, varchar(5) 'at' AS status
FROM avg,group_mark
WHERE mark=avg;
SELECT * from at_avg;


DROP VIEW IF EXISTS below_avg CASCADE;
CREATE VIEW below_avg AS
SELECT group_id, mark,mark-avg AS compared_to_average, varchar(5) 'below' AS status
FROM avg,group_mark
WHERE mark<avg;
SELECT * from below_avg;

DROP VIEW IF EXISTS all_mark CASCADE;
CREATE VIEW all_mark AS
SELECT * FROM above_avg UNION
SELECT * FROM at_avg UNION
SELECT * FROM below_avg;

-- Final answer.
INSERT INTO q10 (group_id, mark, compared_to_average, status)
SELECT * FROM all_mark NATURAL RIGHT JOIN all_groups;
	-- put a final query here so that its results will go into the table.
