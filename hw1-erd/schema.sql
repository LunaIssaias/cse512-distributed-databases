-- CSE 512 HW1 - Entity Relationship Diagram (ERD) & Schema
-- Distributed Database Systems | Arizona State University
-- Author: Luna Sbahtu

-- This SQL script defines the relational schema derived from the HW1 ERD.

-- ─────────────────────────────────────────────
-- Tables
-- ─────────────────────────────────────────────

CREATE TABLE Student (
    student_id   SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    email        VARCHAR(150) UNIQUE NOT NULL,
    dob          DATE,
    major        VARCHAR(100)
);

CREATE TABLE Course (
    course_id    SERIAL PRIMARY KEY,
    course_name  VARCHAR(150) NOT NULL,
    credits      INT CHECK (credits > 0),
    department   VARCHAR(100)
);

CREATE TABLE Enrollment (
    enrollment_id  SERIAL PRIMARY KEY,
    student_id     INT REFERENCES Student(student_id) ON DELETE CASCADE,
    course_id      INT REFERENCES Course(course_id) ON DELETE CASCADE,
    semester       VARCHAR(20),
    grade          CHAR(2)
);

CREATE TABLE Instructor (
    instructor_id  SERIAL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    department     VARCHAR(100)
);

CREATE TABLE Teaches (
    instructor_id  INT REFERENCES Instructor(instructor_id),
    course_id      INT REFERENCES Course(course_id),
    semester       VARCHAR(20),
    PRIMARY KEY (instructor_id, course_id, semester)
);

-- ─────────────────────────────────────────────
-- Sample Data
-- ─────────────────────────────────────────────

INSERT INTO Student (name, email, dob, major) VALUES
    ('Luna Sbahtu', 'luna@asu.edu', '2000-05-10', 'Computer Science'),
    ('Alice Johnson', 'alice@asu.edu', '1999-08-22', 'Data Science');

INSERT INTO Course (course_name, credits, department) VALUES
    ('Distributed Database Systems', 3, 'Engineering'),
    ('Data Mining', 3, 'Engineering');

INSERT INTO Instructor (name, department) VALUES
    ('Dr. Smith', 'Engineering');

INSERT INTO Enrollment (student_id, course_id, semester, grade) VALUES
    (1, 1, 'Fall 2025', 'A'),
    (1, 2, 'Fall 2025', 'A');

INSERT INTO Teaches (instructor_id, course_id, semester) VALUES
    (1, 1, 'Fall 2025');