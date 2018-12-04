-- Solo superior

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q3;

-- You must not change this table definition.
CREATE TABLE q3 (
	assignment_id integer,
	description varchar(100),
	num_solo integer,
	average_solo real,
	num_collaborators integer,
	average_collaborators real,
	average_students_per_submission real
);

-- Convert actual marks to percentage marks;
DROP VIEW IF EXISTS total_mark CASCADE;
CREATE VIEW total_mark AS
SELECT RubricItem.assignment_id, sum(out_of * weight) as total
FROM RubricItem NATURAL JOIN Assignment
GROUP BY RubricItem.assignment_id;

DROP VIEW IF EXISTS percentage CASCADE;
CREATE VIEW percentage AS
SELECT Assignment.assignment_id, AssignmentGroup.group_id, (mark/(total))*100 as percent_mark
FROM Result natural join AssignmentGroup natural join Assignment natural join total_mark;

-- Select all groups who are students work alone aross assignments
DROP VIEW IF EXISTS work_alone CASCADE;
CREATE VIEW work_alone AS
SELECT a.assignment_id, a.group_id
FROM (Membership natural join Assignment natural join AssignmentGroup natural join Result) a
GROUP BY a.assignment_id, a.group_id
HAVING count (a.group_id) = 1;

-- Return null when an assignment has no groups work alone
DROP VIEW IF EXISTS work_alone_final CASCADE;
CREATE VIEW work_alone_final AS
SELECT Assignment.assignment_id, work_alone.group_id
FROM work_alone right join Assignment on work_alone.assignment_id = Assignment.assignment_id;

---- Select all groups who are students work in groups aross assignments
DROP VIEW IF EXISTS work_in_groups_basic CASCADE;
CREATE VIEW work_in_groups_basic AS
SELECT b.assignment_id, b.group_id
FROM (Membership natural join Assignment natural join AssignmentGroup natural left join Result) b
GROUP BY b.assignment_id, b.group_id
HAVING count (b.group_id) > 1;

-- Return null when an assignment has no groups work alone
DROP VIEW IF EXISTS work_in_groups_final CASCADE;
CREATE VIEW work_in_groups_final AS
SELECT Assignment.assignment_id, work_in_groups_basic.group_id
FROM work_in_groups_basic natural right join Assignment;

-- All assignment id and discription
DROP VIEW IF EXISTS assignment_id CASCADE;
CREATE VIEW assignment_id AS
SELECT assignment_id, description
FROM Assignment;

-- Get number of students, average grade of groups declared to be working solo
DROP VIEW IF EXISTS solo_basic CASCADE;
CREATE VIEW solo_basic AS
SELECT c.assignment_id, count(percentage.group_id) as num_solo, avg(percent_mark) as average_solo
FROM (assignment_id natural join work_alone_final) c left join percentage on c.group_id = percentage.group_id
GROUP BY c.assignment_id;

-- Return null when an assignment has no groups work alone
DROP VIEW IF EXISTS solo CASCADE;
CREATE VIEW solo AS
SELECT Assignment.assignment_id, solo_basic.num_solo, solo_basic.average_solo
FROM Assignment natural left join solo_basic;

-- Get number of students, average grade of groups declared to be working in groups,
-- Return null when assignments have no groups working in groups
DROP VIEW IF EXISTS groups CASCADE;
CREATE VIEW groups AS
SELECT d.assignment_id, count(d.username) as num_collaborators, avg(percent_mark) as average_collaborators
FROM (assignment_id natural join work_in_groups_final natural left join Membership) d
natural join percentage WHERE d.group_id = percentage.group_id
GROUP BY d.assignment_id;

-- Table of number of students per group across assignments
DROP VIEW IF EXISTS group_num CASCADE;
CREATE VIEW group_num AS
SELECT assignment_id.assignment_id, count(username)/(count(distinct group_id)) as num_stu
FROM Membership natural join AssignmentGroup natural join assignment_id
GROUP BY assignment_id.assignment_id, Membership.group_id;

-- Average number of students from last table to the average number of students involved in
-- in each group per assignment (solo students included)
DROP VIEW IF EXISTS average_students_per_submission CASCADE;
CREATE VIEW average_students_per_submission AS
SELECT group_num.assignment_id, avg(num_stu) as average_students_per_submission
FROM group_num
GROUP BY group_num.assignment_id;
-- Final answer.

INSERT INTO q3
(SELECT * FROM assignment_id natural left join solo natural left join groups natural left join average_students_per_submission);
	-- put a final query here so that its results will go into the table.
