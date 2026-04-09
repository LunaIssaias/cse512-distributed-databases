// CSE 512 Assignment 3 - Neo4j Advanced Cypher Queries
// Distributed Database Systems | Arizona State University
// Author: Luna Sbahtu

// ─────────────────────────────────────────────
// Setup: Create a social/academic graph
// ─────────────────────────────────────────────

CREATE (:Person {id: 1, name: 'Luna', role: 'Student', gpa: 3.9})
CREATE (:Person {id: 2, name: 'Alice', role: 'Student', gpa: 3.7})
CREATE (:Person {id: 3, name: 'Bob', role: 'Student', gpa: 3.5})
CREATE (:Person {id: 4, name: 'Dr. Smith', role: 'Professor'})

CREATE (:Topic {name: 'Graph Databases'})
CREATE (:Topic {name: 'Distributed Systems'})
CREATE (:Topic {name: 'Machine Learning'})

CREATE (:Paper {title: 'Graph-Based Data Storage', year: 2023})
CREATE (:Paper {title: 'Scalable NoSQL Systems', year: 2022})

// Relationships
MATCH (a:Person {name: 'Luna'}), (b:Person {name: 'Alice'})
CREATE (a)-[:KNOWS {since: 2024}]->(b)

MATCH (a:Person {name: 'Luna'}), (b:Person {name: 'Bob'})
CREATE (a)-[:KNOWS {since: 2025}]->(b)

MATCH (p:Person {name: 'Dr. Smith'}), (paper:Paper {title: 'Graph-Based Data Storage'})
CREATE (p)-[:AUTHORED]->(paper)

MATCH (p:Person {name: 'Luna'}), (t:Topic {name: 'Graph Databases'})
CREATE (p)-[:INTERESTED_IN]->(t)

MATCH (paper:Paper {title: 'Graph-Based Data Storage'}), (t:Topic {name: 'Graph Databases'})
CREATE (paper)-[:ABOUT]->(t)

// ─────────────────────────────────────────────
// Query 1: OPTIONAL MATCH — include people with no interests
// ─────────────────────────────────────────────

MATCH (p:Person)
OPTIONAL MATCH (p)-[:INTERESTED_IN]->(t:Topic)
RETURN p.name, COALESCE(t.name, 'No interests listed') AS topic

// ─────────────────────────────────────────────
// Query 2: Pattern comprehension — list all topics per person
// ─────────────────────────────────────────────

MATCH (p:Person)
RETURN p.name,
       [(p)-[:INTERESTED_IN]->(t:Topic) | t.name] AS interests

// ─────────────────────────────────────────────
// Query 3: Aggregation — people who know the most others
// ─────────────────────────────────────────────

MATCH (p:Person)-[:KNOWS]->(other:Person)
RETURN p.name, COUNT(other) AS connections
ORDER BY connections DESC

// ─────────────────────────────────────────────
// Query 4: Variable-length path — friends of friends
// ─────────────────────────────────────────────

MATCH (p:Person {name: 'Luna'})-[:KNOWS*1..2]->(other:Person)
WHERE other.name <> 'Luna'
RETURN DISTINCT other.name AS reachable_person

// ─────────────────────────────────────────────
// Query 5: Recommend papers based on shared topic interest
// ─────────────────────────────────────────────

MATCH (p:Person)-[:INTERESTED_IN]->(t:Topic)<-[:ABOUT]-(paper:Paper)
RETURN p.name AS person, paper.title AS recommended_paper, t.name AS shared_topic

// ─────────────────────────────────────────────
// Query 6: MERGE — add or update a node safely
// ─────────────────────────────────────────────

MERGE (p:Person {name: 'Charlie'})
ON CREATE SET p.role = 'Student', p.gpa = 3.2
ON MATCH SET p.gpa = 3.4
RETURN p

// ─────────────────────────────────────────────
// Query 7: WITH clause — filter aggregated results
// ─────────────────────────────────────────────

MATCH (p:Person)-[:KNOWS]->(other:Person)
WITH p, COUNT(other) AS conn
WHERE conn >= 1
RETURN p.name, conn
ORDER BY conn DESC

// ─────────────────────────────────────────────
// Query 8: UNWIND — expand a list into rows
// ─────────────────────────────────────────────

WITH ['Graph Databases', 'Distributed Systems', 'Machine Learning'] AS topics
UNWIND topics AS topic
MATCH (t:Topic {name: topic})
RETURN t.name, COUNT { (t)<-[:ABOUT]-(:Paper) } AS paper_count
