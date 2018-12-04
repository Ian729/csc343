-- Never solo by choice

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q8;

-- You must not change this table definition.
CREATE TABLE q8 (
	username varchar(25),
	group_average real,
	solo_average real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)

-- All group assignments
DROP VIEW IF EXISTS assignment_allow_group CASCADE;
CREATE VIEW assignment_allow_group AS
SELECT assignment_id FROM Assignment
WHERE group_max > 1;

DROP VIEW IF EXISTS assignment_solo CASCADE;
CREATE VIEW assignment_solo AS
SELECT assignment_id FROM Assignment
WHERE group_max = 1;

-- All students and groups in Group Assignments
DROP VIEW IF EXISTS students_in_group_assignments CASCADE;
CREATE VIEW students_in_group_assignments AS
SELECT username,group_id,assignment_id
FROM Membership NATURAL JOIN AssignmentGroup NATURAL JOIN assignment_allow_group;

-- All students that choose to work in groups all the time
DROP VIEW IF EXISTS group_and_students CASCADE;
CREATE VIEW group_and_students AS
SELECT username
FROM students_in_group_assignments
GROUP BY username
HAVING count(assignment_id)= (SELECT count(assignment_id) FROM assignment_allow_group);

-- All satisfying students
DROP VIEW IF EXISTS group_students CASCADE;
CREATE VIEW group_students AS
SELECT assignment_id,group_id,username
FROM group_and_students NATURAL JOIN Membership
NATURAL JOIN AssignmentGroup;

-- All satisfying students that contribute
DROP VIEW IF EXISTS group_students_that_contribute CASCADE;
CREATE VIEW group_students_that_contribute AS
SELECT username
FROM group_students NATURAL JOIN Submissions
GROUP by username
HAVING count(DISTINCT assignment_id) =
(SELECT count(assignment_id) FROM Assignment);

-- Assignments and their total marks
DROP VIEW IF EXISTS total_mark CASCADE;
CREATE VIEW total_mark AS
SELECT assignment_id,sum(out_of*weight) AS total
FROM RubricItem NATURAL JOIN Assignment
GROUP BY assignment_id;

-- Groups and their earned marks
DROP VIEW IF EXISTS group_percentage CASCADE;
CREATE VIEW group_percentage AS
SELECT group_id,mark/total*100 AS mark,assignment_id
FROM Result NATURAL JOIN total_mark NATURAL JOIN AssignmentGroup;

DROP VIEW IF EXISTS individual_percentage CASCADE;
CREATE VIEW individual_percentage AS
SELECT assignment_id,group_id,username,mark
FROM group_percentage NATURAL JOIN Membership;

DROP VIEW IF EXISTS contribute_student_and_mark CASCADE;
CREATE VIEW contribute_student_and_mark AS
SELECT * FROM individual_percentage
NATURAL JOIN group_students_that_contribute;

DROP VIEW IF EXISTS percentage CASCADE;
CREATE VIEW percentage AS
SELECT *,mark/total*100 AS percentage FROM result NATURAL JOIN AssignmentGroup NATURAL JOIN total_mark;

DROP VIEW IF EXISTS contribute_student_averge_mark_allow_group CASCADE;
CREATE VIEW contribute_student_averge_mark_allow_group AS
SELECT username, avg(percentage) AS group_average
FROM percentage NATURAL JOIN membership NATURAL JOIN Assignmentgroup NATURAL JOIN assignment_allow_group
WHERE username IN (SELECT username FROM contribute_student_and_mark)
GROUP BY username;

DROP VIEW IF EXISTS contribute_student_averge_mark_not_allow_group CASCADE;
CREATE VIEW contribute_student_averge_mark_not_allow_group AS
SELECT username, avg(percentage) AS solo_average
FROM percentage NATURAL JOIN membership NATURAL JOIN Assignmentgroup NATURAL JOIN assignment_solo
WHERE username IN (SELECT username FROM contribute_student_and_mark)
GROUP BY username;

-- Define views for your intermediate steps here.

-- Final answer.
INSERT INTO q8
SELECT *
FROM contribute_student_averge_mark_allow_group
NATURAL FULL OUTER JOIN contribute_student_averge_mark_not_allow_group
	-- put a final query here so that its results will go into the table.
