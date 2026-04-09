-- CSE 512 HW2 - SQL Queries
-- Distributed Database Systems | Arizona State University
-- Author: Luna Sbahtu

-- ─────────────────────────────────────────────
-- Query 1: List all students and their enrolled courses
-- ─────────────────────────────────────────────
SELECT s.name AS student_name, c.course_name, e.semester, e.grade
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON e.course_id = c.course_id
ORDER BY s.name;

-- ─────────────────────────────────────────────
-- Query 2: Count enrollments per course
-- ─────────────────────────────────────────────
SELECT c.course_name, COUNT(e.enrollment_id) AS total_enrolled
FROM Course c
LEFT JOIN Enrollment e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY total_enrolled DESC;

-- ─────────────────────────────────────────────
-- Query 3: Find students who got an 'A' grade
-- ─────────────────────────────────────────────
SELECT s.name, c.course_name, e.grade
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Course c ON e.course_id = c.course_id
WHERE e.grade = 'A';

-- ─────────────────────────────────────────────
-- Query 4: Average credits per department
-- ─────────────────────────────────────────────
SELECT department, AVG(credits) AS avg_credits
FROM Course
GROUP BY department;

-- ─────────────────────────────────────────────
-- Query 5: Instructors teaching more than one course
-- ─────────────────────────────────────────────
SELECT i.name AS instructor_name, COUNT(t.course_id) AS courses_taught
FROM Instructor i
JOIN Teaches t ON i.instructor_id = t.instructor_id
GROUP BY i.name
HAVING COUNT(t.course_id) > 1;

-- ─────────────────────────────────────────────
-- Query 6: Students not enrolled in any course
-- ─────────────────────────────────────────────
SELECT s.name
FROM Student s
LEFT JOIN Enrollment e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;