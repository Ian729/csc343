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
INSERT INTO MarkusUser VALUES ('s3', 'tln1', 'tfn1', 'student');
INSERT INTO MarkusUser VALUES ('s4', 'tln1', 'tfn1', 'student');
INSERT INTO MarkusUser VALUES ('s5', 'tln1', 'tfn1', 'student');
INSERT INTO MarkusUser VALUES ('s6', 'tln1', 'tfn1', 'student');
INSERT INTO MarkusUser VALUES ('s7', 'tln1', 'tfn1', 'student');
INSERT INTO MarkusUser VALUES ('s8', 'tln1', 'tfn1', 'student');
INSERT INTO MarkusUser VALUES ('t1', 'tln1', 'tfn1', 'TA');
INSERT INTO MarkusUser VALUES ('t2', 'tln1', 'tfn1', 'TA');


INSERT INTO Assignment VALUES (1000, 'a1', '2017-02-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (2000, 'a2', '2017-02-09 20:00', 1, 2);
INSERT INTO Assignment VALUES (3000, 'a3', '2017-02-10 20:00', 1, 2);




INSERT INTO Required VALUES (1000, 'A1.pdf');
INSERT INTO Required VALUES (2000, 'A2.pdf');
INSERT INTO Required VALUES (3000, 'A3.pdf');

INSERT INTO AssignmentGroup VALUES (1, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (2, 1000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (3, 2000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (4, 2000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (5, 3000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (6, 3000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (7, 2000, 'repo_url');
INSERT INTO AssignmentGroup VALUES (8, 2000, 'repo_url');



INSERT INTO Membership VALUES ('s1', 1);
INSERT INTO Membership VALUES ('s2', 1);
INSERT INTO Membership VALUES ('s3', 2);
INSERT INTO Membership VALUES ('s4', 2);
INSERT INTO Membership VALUES ('s5', 3);
INSERT INTO Membership VALUES ('s6', 3);
INSERT INTO Membership VALUES ('s7', 4);
INSERT INTO Membership VALUES ('s8', 5);
INSERT INTO Membership VALUES ('s1', 6);
INSERT INTO Membership VALUES ('s1', 7);
INSERT INTO Membership VALUES ('s2', 7);
INSERT INTO Membership VALUES ('s3', 8);
INSERT INTO Membership VALUES ('s4', 8);

INSERT INTO Submissions VALUES (10, 'A1.pdf', 's1', 1, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (20, 'A1.pdf', 's3', 2, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (30, 'A1.pdf', 's5', 3, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (40, 'A1.pdf', 's7', 4, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (50, 'A1.pdf', 's8', 5, '2017-02-08 19:59');

INSERT INTO Grader VALUES (1, 't1');
INSERT INTO Grader VALUES (2, 't1');
INSERT INTO Grader VALUES (3, 't1');
INSERT INTO Grader VALUES (4, 't1');
INSERT INTO Grader VALUES (5, 't1');
INSERT INTO Grader VALUES (6, 't1');
INSERT INTO Grader VALUES (7, 't1');
INSERT INTO Grader VALUES (8, 't1');


INSERT INTO RubricItem VALUES (100, 1000, 'style', 100, 0.25);
INSERT INTO RubricItem VALUES (200, 1000, 'tester', 80, 0.75);
INSERT INTO RubricItem VALUES (300, 2000, 'style', 100, 0.25);
INSERT INTO RubricItem VALUES (400, 2000, 'tester', 80, 0.75);
INSERT INTO RubricItem VALUES (500, 3000, 'style', 100, 0.25);
INSERT INTO RubricItem VALUES (600, 3000, 'tester', 80, 0.75);

INSERT INTO Grade VALUES (1, 100, 3);
INSERT INTO Grade VALUES (1, 200, 9);

INSERT INTO Result VALUES (1, 90, true);
INSERT INTO Result VALUES (2, 80, true);
INSERT INTO Result VALUES (4, 70, true);
INSERT INTO Result VALUES (5, 50, true);
INSERT INTO Result VALUES (6, 40, true);
INSERT INTO Result VALUES (7, 40, true);
INSERT INTO Result VALUES (8, 60, true);
