-- High coverage

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q7;

-- You must not change this table definition.
CREATE TABLE q7 (
	ta varchar(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS all_assignments CASCADE;
CREATE VIEW all_assignments AS
SELECT assignment_id FROM Assignment;

DROP VIEW IF EXISTS ta_assignments CASCADE;
CREATE VIEW ta_assignments AS
SELECT username,assignment_id FROM AssignmentGroup NATURAL JOIN Grader;
SELECT * FROM ta_assignments;
-- Define views for your intermediate steps here.

DROP VIEW IF EXISTS ta_not_grade_assignments CASCADE;
CREATE VIEW ta_not_grade_assignments AS
SELECT username,assignment_id FROM AssignmentGroup,Grader
EXCEPT SELECT username,assignment_id FROM ta_assignments;
SELECT * FROM ta_not_grade_assignments;
-- WHERE username NOT IN
-- 	(SELECT username FROM ta_assignments);
-- SELECT * FROM ta_not_grade_assignments;

DROP VIEW IF EXISTS ta_that_grade_all_assignments CASCADE;
CREATE VIEW ta_that_grade_all_assignments AS
SELECT username FROM grader
EXCEPT
SELECT username FROM ta_not_grade_assignments;
SELECT * FROM ta_that_grade_all_assignments;

DROP VIEW IF EXISTS student_group CASCADE;
CREATE VIEW student_group AS
SELECT username AS student_name, group_id FROM AssignmentGroup NATURAL JOIN Membership;

DROP VIEW IF EXISTS ta_student CASCADE;
CREATE VIEW ta_student AS
SELECT username, student_name FROM student_group NATURAL JOIN Grader;

DROP VIEW IF EXISTS ta_all_student CASCADE;
CREATE VIEW ta_all_student AS
SELECT DISTINCT G.username, M.username AS student_name FROM Grader G, MarkusUser M
WHERE M.type='student';

DROP VIEW IF EXISTS ta_not_student CASCADE;
CREATE VIEW ta_not_student AS
SELECT * FROM ta_all_student
EXCEPT
SELECT * FROM ta_student;

DROP VIEW IF EXISTS answer CASCADE;
CREATE VIEW answer AS
SELECT DISTINCT username FROM ta_that_grade_all_assignments
EXCEPT
SELECT DISTINCT username FROM ta_not_student;

-- Final answer.
INSERT INTO q7
	SELECT username AS ta FROM answer;
	-- put a final query here so that its results will go into the table.
