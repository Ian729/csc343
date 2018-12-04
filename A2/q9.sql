-- Inseparable

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q9;

-- You must not change this table definition.
CREATE TABLE q9 (
	student1 varchar(25),
	student2 varchar(25)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)

-- All group assignments
DROP VIEW IF EXISTS assignment_allow_group CASCADE;
CREATE VIEW assignment_allow_group AS
SELECT assignment_id FROM Assignment
WHERE group_max > 1;

-- All students and groups in Group Assignments
DROP VIEW IF EXISTS students_in_group_assignments CASCADE;
CREATE VIEW students_in_group_assignments AS
SELECT username,group_id,assignment_id
FROM Membership NATURAL JOIN AssignmentGroup NATURAL JOIN assignment_allow_group;

DROP VIEW IF EXISTS students_group CASCADE;
CREATE VIEW students_group AS
SELECT S1.username AS student1,S2.username AS student2,S1.group_id,S1.assignment_id
FROM students_in_group_assignments S1, students_in_group_assignments S2
WHERE S1.group_id = S2.group_id AND S1.username<S2.username;

DROP VIEW IF EXISTS ans CASCADE;
CREATE VIEW ans AS
SELECT student1,student2
FROM students_group
GROUP BY student1, student2
HAVING count(assignment_id) = (SELECT count(assignment_id) FROM Assignment);
-- Final answer.
INSERT INTO q9
SELECT student1, student2 FROM ans;
	-- put a final query here so that its results will go into the table.
