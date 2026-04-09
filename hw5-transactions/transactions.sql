-- CSE 512 HW5 - Database Transactions
-- Distributed Database Systems | Arizona State University
-- Author: Luna Sbahtu

-- ─────────────────────────────────────────────
-- Transaction 1: Transfer enrollment between courses (ACID demo)
-- ─────────────────────────────────────────────
BEGIN;

UPDATE Enrollment
SET course_id = 2
WHERE student_id = 1 AND course_id = 1;

-- Verify the change before committing
SELECT * FROM Enrollment WHERE student_id = 1;

COMMIT;

-- ─────────────────────────────────────────────
-- Transaction 2: Rollback on error
-- ─────────────────────────────────────────────
BEGIN;

INSERT INTO Enrollment (student_id, course_id, semester, grade)
VALUES (1, 1, 'Spring 2026', 'A');

-- Simulate an error condition — rollback
ROLLBACK;

-- ─────────────────────────────────────────────
-- Transaction 3: Isolation level demo (REPEATABLE READ)
-- ─────────────────────────────────────────────
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN;

SELECT * FROM Student WHERE student_id = 1;

-- Another transaction could insert here; this session won't see it
SELECT * FROM Student WHERE student_id = 1;

COMMIT;

-- ─────────────────────────────────────────────
-- Transaction 4: Deadlock prevention using ordered locking
-- ─────────────────────────────────────────────
-- Always lock rows in primary key order to prevent deadlocks
BEGIN;

SELECT * FROM Student WHERE student_id = 1 FOR UPDATE;
SELECT * FROM Course WHERE course_id = 1 FOR UPDATE;

UPDATE Enrollment SET grade = 'B' WHERE student_id = 1 AND course_id = 1;

COMMIT;

-- ─────────────────────────────────────────────
-- Transaction 5: Savepoints
-- ─────────────────────────────────────────────
BEGIN;

INSERT INTO Student (name, email, dob, major)
VALUES ('Test User', 'test@asu.edu', '2001-01-01', 'CS');

SAVEPOINT before_enrollment;

INSERT INTO Enrollment (student_id, course_id, semester, grade)
VALUES (3, 99, 'Fall 2025', 'A');  -- course 99 doesn't exist

-- Roll back only to savepoint, keep student insert
ROLLBACK TO SAVEPOINT before_enrollment;

COMMIT;