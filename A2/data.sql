-- If there is already any data in these tables, empty it out.

TRUNCATE TABLE Result CASCADE;
TRUNCATE TABLE Grade CASCADE;
TRUNCATE TABLE RubricItem CASCADE;
TRUNCATE TABLE Grader CASCADE;
TRUNCATE TABLE Submissions CASCADE;
TRUNCATE TABLE Membership CASCADE;
TRUNCATE TABLE AssignmentGroup CASCADE;
TRUNCATE TABLE Required CASCADE;
TRUNCATE TABLE Assignment CASCADE;
TRUNCATE TABLE MarkusUser CASCADE;


-- Now insert data from scratch.

INSERT INTO MarkusUser VALUES ('i1', 'iln1', 'ifn1', 'instructor');
INSERT INTO MarkusUser VALUES ('s1', 'sln1', 'sfn1', 'student');
INSERT INTO MarkusUser VALUES ('s2', 'sln2', 'sfn2', 'student');
INSERT INTO MarkusUser VALUES ('s3', 'sln3', 'sfn3', 'student');
INSERT INTO MarkusUser VALUES ('s4', 'sln4', 'sfn4', 'student');
INSERT INTO MarkusUser VALUES ('s5', 'sln5', 'sfn5', 'student');
INSERT INTO MarkusUser VALUES ('s6', 'sln6', 'sfn6', 'student');
INSERT INTO MarkusUser VALUES ('s7', 'sln7', 'sfn7', 'student');
INSERT INTO MarkusUser VALUES ('s8', 'sln8', 'sfn8', 'student');
INSERT INTO MarkusUser VALUES ('s9', 'sln9', 'sfn9', 'student');
INSERT INTO MarkusUser VALUES ('t1', 'tln1', 'tfn1', 'TA');
INSERT INTO MarkusUser VALUES ('t2', 'tln2', 'tfn2', 'TA');
INSERT INTO MarkusUser VALUES ('t3', 'tln3', 'tfn3', 'TA');


INSERT INTO Assignment VALUES (1000, 'A1', '2017-02-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (2000, 'A2', '2017-03-01 20:00', 1, 2);
-- INSERT INTO Assignment VALUES (3000, 'A3', '2017-03-01 20:00', 1, 1);

INSERT INTO Required VALUES (1000, 'A1.pdf');
INSERT INTO Required VALUES (2000, 'A2.pdf');
-- INSERT INTO Required VALUES (3000, 'A3.pdf');

INSERT INTO AssignmentGroup VALUES (1, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (3, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (4, 2000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (5, 2000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (6, 2000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (7, 2000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (8, 2000, 'repo_url');
-- INSERT INTO AssignmentGroup VALUES (9, 3000, 'repo_url');

INSERT INTO Membership VALUES ('s1', 1);
INSERT INTO Membership VALUES ('s2', 2);
INSERT INTO Membership VALUES ('s3', 2);
INSERT INTO Membership VALUES ('s4', 3);
INSERT INTO Membership VALUES ('s5', 3);
INSERT INTO Membership VALUES ('s6', 4);
INSERT INTO Membership VALUES ('s7', 4);
INSERT INTO Membership VALUES ('s8', 5);
INSERT INTO Membership VALUES ('s9', 6);
INSERT INTO Membership VALUES ('s4', 7);
INSERT INTO Membership VALUES ('s5', 7);
INSERT INTO Membership VALUES ('s2', 8);
INSERT INTO Membership VALUES ('s3', 8);
-- INSERT INTO Membership VALUES ('s2', 9);


INSERT INTO Submissions VALUES (3000, 'A1.pdf', 's1', 1, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (4000, 'A1.pdf', 's2', 2, '2017-02-10 19:59');
INSERT INTO Submissions VALUES (4010, 'A1.pdf', 's2', 2, '2017-02-09 19:59');
INSERT INTO Submissions VALUES (8000, 'A2.pdf', 's2', 8, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (6000, 'A1.pdf', 's3', 2, '2017-03-01 19:59');
INSERT INTO Submissions VALUES (9000, 'A2.pdf', 's3', 8, '2017-02-08 19:59');
-- INSERT INTO Submissions VALUES (10000, 'A3.pdf', 's2', 9, '2017-02-08 19:59');


INSERT INTO Grader VALUES (1, 't1');
INSERT INTO Grader VALUES (4, 't1');
INSERT INTO Grader VALUES (5, 't1');
INSERT INTO Grader VALUES (6, 't1');
INSERT INTO Grader VALUES (2, 't1');
INSERT INTO Grader VALUES (3, 't1');

INSERT INTO RubricItem VALUES (4000, 1000, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4001, 1000, 'tester', 12, 0.75);
INSERT INTO RubricItem VALUES (4002, 2000, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4003, 2000, 'tester', 12, 0.75);

INSERT INTO Grade VALUES (1, 4000, 3);
INSERT INTO Grade VALUES (1, 4001, 9);
INSERT INTO Grade VALUES (2, 4002, 3);
INSERT INTO Grade VALUES (2, 4003, 9);


INSERT INTO Result VALUES (1, 2, true);
INSERT INTO Result VALUES (2, 18, true);
INSERT INTO Result VALUES (3, 10, true);
