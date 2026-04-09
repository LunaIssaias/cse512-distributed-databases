-- CSE 512 HW7 - CockroachDB Distributed SQL
-- Distributed Database Systems | Arizona State University
-- Author: Luna Sbahtu

-- ─────────────────────────────────────────────
-- CockroachDB Setup: Create Database and Tables
-- ─────────────────────────────────────────────

CREATE DATABASE IF NOT EXISTS university;
USE university;

CREATE TABLE IF NOT EXISTS students (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name       STRING NOT NULL,
    email      STRING UNIQUE NOT NULL,
    major      STRING,
    created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS courses (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        STRING NOT NULL,
    credits     INT CHECK (credits > 0),
    department  STRING
);

CREATE TABLE IF NOT EXISTS enrollments (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID REFERENCES students(id),
    course_id  UUID REFERENCES courses(id),
    semester   STRING,
    grade      STRING(2)
);

-- ─────────────────────────────────────────────
-- Insert Sample Data
-- ─────────────────────────────────────────────

INSERT INTO students (name, email, major) VALUES
    ('Luna Sbahtu', 'luna@asu.edu', 'Computer Science'),
    ('Alice Johnson', 'alice@asu.edu', 'Data Science');

INSERT INTO courses (name, credits, department) VALUES
    ('Distributed Database Systems', 3, 'Engineering'),
    ('Data Mining', 3, 'Engineering');

-- ─────────────────────────────────────────────
-- CockroachDB Distributed Transaction Demo
-- ─────────────────────────────────────────────

BEGIN;
INSERT INTO enrollments (student_id, course_id, semester, grade)
SELECT s.id, c.id, 'Fall 2025', 'A'
FROM students s, courses c
WHERE s.email = 'luna@asu.edu' AND c.name = 'Distributed Database Systems';
COMMIT;

-- ─────────────────────────────────────────────
-- Query: Join across distributed tables
-- ─────────────────────────────────────────────

SELECT s.name, c.name AS course, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN courses c ON e.course_id = c.id
ORDER BY s.name;

-- ─────────────────────────────────────────────
-- CockroachDB: Show cluster node info
-- ─────────────────────────────────────────────
-- Run in CockroachDB shell:
-- > SHOW CLUSTER SETTING cluster.organization;
-- > SELECT node_id, address, is_available FROM crdb_internal.gossip_nodes;

-- ─────────────────────────────────────────────
-- CockroachDB: Geo-partitioning example
-- ─────────────────────────────────────────────
ALTER TABLE students PARTITION BY LIST (major) (
    PARTITION cs VALUES IN ('Computer Science'),
    PARTITION ds VALUES IN ('Data Science'),
    PARTITION other VALUES IN (DEFAULT)
);