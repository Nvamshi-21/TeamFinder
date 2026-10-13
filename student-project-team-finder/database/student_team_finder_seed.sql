USE student_team_finder;

-- Development seed data for initial testing and demo flows.
-- Passwords are intentionally stored as BCrypt hashes matching the application seed account values.
-- The shown values correspond to the local development demo credentials.

INSERT INTO student (student_id, full_name, email, password, branch, academic_year, bio, availability, role, interests, avatar_url)
VALUES
  (1, 'Priya Nair', 'admin@campus.dev', '$2a$10$7KZyLZsH3u8z2L1dUP4WBO6K3eow0HiFvY0h9wq2rJqm9Y.4nuQ0K', 'Information Technology', 4, 'Platform administration and project quality review.', 'AVAILABLE', 'ADMIN', 'Academic operations, accessibility, community support', NULL),
  (2, 'Aisha Sharma', 'aisha@campus.dev', '$2a$10$7KZyLZsH3u8z2L1dUP4WBO6K3eow0HiFvY0h9wq2rJqm9Y.4nuQ0K', 'Computer Science', 4, 'Backend-focused student with an interest in learning systems and public-interest tech.', 'AVAILABLE', 'STUDENT', 'EdTech, sustainability, backend systems', NULL),
  (3, 'Arjun Mehta', 'arjun@campus.dev', '$2a$10$7KZyLZsH3u8z2L1dUP4WBO6K3eow0HiFvY0h9wq2rJqm9Y.4nuQ0K', 'Computer Science', 3, 'I enjoy practical academic projects where the team communicates clearly and learns together.', 'AVAILABLE', 'STUDENT', 'Web development, accessibility, design systems', NULL),
  (4, 'Neha Iyer', 'neha@campus.dev', '$2a$10$7KZyLZsH3u8z2L1dUP4WBO6K3eow0HiFvY0h9wq2rJqm9Y.4nuQ0K', 'Information Technology', 4, 'Product design and user research for education and student wellbeing.', 'AVAILABLE', 'STUDENT', 'Product design, EdTech, user research', NULL)
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name);

INSERT INTO skill (skill_name)
VALUES ('Java'),('Spring Boot'),('MySQL'),('React'),('HTML'),('CSS'),('JavaScript'),('Python'),('Figma'),('Git'),('Docker')
ON DUPLICATE KEY UPDATE skill_name = skill_name;

-- Simple sample insertion pattern: link students to skills using their known technical strengths.
INSERT INTO student_skill (student_id, skill_id, proficiency_level)
SELECT s.student_id, sk.skill_id, 'ADVANCED'
FROM student s JOIN skill sk ON sk.skill_name = 'Java'
WHERE s.email = 'aisha@campus.dev'
UNION ALL
SELECT s.student_id, sk.skill_id, 'ADVANCED'
FROM student s JOIN skill sk ON sk.skill_name = 'Spring Boot'
WHERE s.email = 'aisha@campus.dev'
UNION ALL
SELECT s.student_id, sk.skill_id, 'INTERMEDIATE'
FROM student s JOIN skill sk ON sk.skill_name = 'MySQL'
WHERE s.email = 'aisha@campus.dev'
UNION ALL
SELECT s.student_id, sk.skill_id, 'ADVANCED'
FROM student s JOIN skill sk ON sk.skill_name = 'React'
WHERE s.email = 'arjun@campus.dev'
UNION ALL
SELECT s.student_id, sk.skill_id, 'ADVANCED'
FROM student s JOIN skill sk ON sk.skill_name = 'JavaScript'
WHERE s.email = 'arjun@campus.dev'
UNION ALL
SELECT s.student_id, sk.skill_id, 'ADVANCED'
FROM student s JOIN skill sk ON sk.skill_name = 'HTML'
WHERE s.email = 'arjun@campus.dev'
UNION ALL
SELECT s.student_id, sk.skill_id, 'ADVANCED'
FROM student s JOIN skill sk ON sk.skill_name = 'CSS'
WHERE s.email = 'arjun@campus.dev'
UNION ALL
SELECT s.student_id, sk.skill_id, 'ADVANCED'
FROM student s JOIN skill sk ON sk.skill_name = 'Figma'
WHERE s.email = 'neha@campus.dev'
ON DUPLICATE KEY UPDATE proficiency_level = VALUES(proficiency_level);

-- Example project creation for reference.
INSERT INTO project (project_id, title, short_description, description, category, team_size, status, owner_id)
VALUES
  (1, 'Smart Attendance Companion', 'A privacy-aware attendance and engagement workspace for instructors.', 'Build a web platform that helps faculty understand attendance trends while giving students clear, respectful feedback.', 'EdTech', 4, 'OPEN_FOR_MEMBERS', 2)
ON DUPLICATE KEY UPDATE title = VALUES(title);

INSERT INTO project_skill (project_id, skill_id, skill_type)
SELECT 1, sk.skill_id, 'REQUIRED'
FROM skill sk WHERE sk.skill_name = 'Java'
UNION ALL
SELECT 1, sk.skill_id, 'REQUIRED'
FROM skill sk WHERE sk.skill_name = 'Spring Boot'
UNION ALL
SELECT 1, sk.skill_id, 'REQUIRED'
FROM skill sk WHERE sk.skill_name = 'MySQL'
UNION ALL
SELECT 1, sk.skill_id, 'PREFERRED'
FROM skill sk WHERE sk.skill_name = 'React'
UNION ALL
SELECT 1, sk.skill_id, 'PREFERRED'
FROM skill sk WHERE sk.skill_name = 'Figma'
ON DUPLICATE KEY UPDATE skill_type = VALUES(skill_type);

INSERT INTO team_member (project_id, student_id, role)
SELECT 1, s.student_id, 'TEAM_LEAD'
FROM student s WHERE s.email = 'aisha@campus.dev'
ON DUPLICATE KEY UPDATE role = VALUES(role);

INSERT INTO request (project_id, from_student_id, to_student_id, status)
SELECT 1, s1.student_id, s2.student_id, 'PENDING'
FROM student s1 JOIN student s2 ON s2.email = 'arjun@campus.dev'
WHERE s1.email = 'aisha@campus.dev'
ON DUPLICATE KEY UPDATE status = VALUES(status);

INSERT INTO milestone (project_id, title, description, due_date, status, progress_percentage)
VALUES
  (1, 'Research and system map', 'Interview stakeholders and agree core workflows.', DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'IN_PROGRESS', 55),
  (1, 'API foundation', 'Set up authentication and project APIs.', DATE_ADD(CURDATE(), INTERVAL 18 DAY), 'NOT_STARTED', 0)
ON DUPLICATE KEY UPDATE title = VALUES(title);

INSERT INTO activity_log (project_id, student_id, activity_type, message)
SELECT 1, s.student_id, 'PROJECT_CREATED', 'Aisha Sharma created the project.'
FROM student s WHERE s.email = 'aisha@campus.dev'
ON DUPLICATE KEY UPDATE message = VALUES(message);
