// CSE 512 HW9 - Neo4j Graph Database
// Distributed Database Systems | Arizona State University
// Author: Luna Sbahtu

// ─────────────────────────────────────────────
// Create Nodes
// ─────────────────────────────────────────────

CREATE (:Student {id: 1, name: 'Luna Sbahtu', email: 'luna@asu.edu', major: 'Computer Science'})
CREATE (:Student {id: 2, name: 'Alice Johnson', email: 'alice@asu.edu', major: 'Data Science'})

CREATE (:Course {id: 1, name: 'Distributed Database Systems', credits: 3, department: 'Engineering'})
CREATE (:Course {id: 2, name: 'Data Mining', credits: 3, department: 'Engineering'})
CREATE (:Course {id: 3, name: 'Data Visualization', credits: 3, department: 'Engineering'})

CREATE (:Instructor {id: 1, name: 'Dr. Smith', department: 'Engineering'})
CREATE (:Instructor {id: 2, name: 'Dr. Patel', department: 'Engineering'})

// ─────────────────────────────────────────────
// Create Relationships
// ─────────────────────────────────────────────

MATCH (s:Student {id: 1}), (c:Course {id: 1})
CREATE (s)-[:ENROLLED_IN {semester: 'Fall 2025', grade: 'A'}]->(c)

MATCH (s:Student {id: 1}), (c:Course {id: 2})
CREATE (s)-[:ENROLLED_IN {semester: 'Fall 2025', grade: 'A'}]->(c)

MATCH (s:Student {id: 2}), (c:Course {id: 3})
CREATE (s)-[:ENROLLED_IN {semester: 'Fall 2025', grade: 'B'}]->(c)

MATCH (i:Instructor {id: 1}), (c:Course {id: 1})
CREATE (i)-[:TEACHES {semester: 'Fall 2025'}]->(c)

MATCH (i:Instructor {id: 2}), (c:Course {id: 2})
CREATE (i)-[:TEACHES {semester: 'Fall 2025'}]->(c)

// ─────────────────────────────────────────────
// Query 1: Find all courses a student is enrolled in
// ─────────────────────────────────────────────

MATCH (s:Student {name: 'Luna Sbahtu'})-[:ENROLLED_IN]->(c:Course)
RETURN s.name AS student, c.name AS course

// ─────────────────────────────────────────────
// Query 2: Find all students taught by an instructor (via course)
// ─────────────────────────────────────────────

MATCH (i:Instructor)-[:TEACHES]->(c:Course)<-[:ENROLLED_IN]-(s:Student)
RETURN i.name AS instructor, c.name AS course, s.name AS student

// ─────────────────────────────────────────────
// Query 3: Find students with grade 'A'
// ─────────────────────────────────────────────

MATCH (s:Student)-[e:ENROLLED_IN]->(c:Course)
WHERE e.grade = 'A'
RETURN s.name, c.name, e.grade

// ─────────────────────────────────────────────
// Query 4: Count enrollments per course
// ─────────────────────────────────────────────

MATCH (s:Student)-[:ENROLLED_IN]->(c:Course)
RETURN c.name AS course, COUNT(s) AS total_students
ORDER BY total_students DESC

// ─────────────────────────────────────────────
// Query 5: Shortest path between two students via shared courses
// ─────────────────────────────────────────────

MATCH path = shortestPath(
  (s1:Student {name: 'Luna Sbahtu'})-[*]-(s2:Student {name: 'Alice Johnson'})
)
RETURN path

// ─────────────────────────────────────────────
// Query 6: Delete all nodes and relationships (cleanup)
// ─────────────────────────────────────────────

// MATCH (n) DETACH DELETE n
