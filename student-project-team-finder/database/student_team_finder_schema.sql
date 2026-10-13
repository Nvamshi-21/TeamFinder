CREATE DATABASE IF NOT EXISTS student_team_finder
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE student_team_finder;

CREATE TABLE IF NOT EXISTS student (
    student_id BIGINT NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    password VARCHAR(255) NOT NULL,
    branch VARCHAR(100) NOT NULL,
    academic_year INT NOT NULL,
    bio TEXT,
    availability ENUM('AVAILABLE','LIMITED','UNAVAILABLE') NOT NULL DEFAULT 'AVAILABLE',
    role ENUM('STUDENT','ADMIN') NOT NULL DEFAULT 'STUDENT',
    interests VARCHAR(500) DEFAULT '',
    avatar_url VARCHAR(500) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id),
    UNIQUE KEY uk_student_email (email),
    KEY idx_student_branch_year (branch, academic_year),
    KEY idx_student_availability (availability),
    KEY idx_student_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS skill (
    skill_id BIGINT NOT NULL AUTO_INCREMENT,
    skill_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (skill_id),
    UNIQUE KEY uk_skill_name (skill_name),
    KEY idx_skill_name (skill_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS student_skill (
    id BIGINT NOT NULL AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    skill_id BIGINT NOT NULL,
    proficiency_level ENUM('BEGINNER','INTERMEDIATE','ADVANCED') NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_student_skill (student_id, skill_id),
    KEY idx_student_skill_student_id (student_id),
    KEY idx_student_skill_skill_id (skill_id),
    CONSTRAINT fk_student_skill_student FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_student_skill_skill FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS project (
    project_id BIGINT NOT NULL AUTO_INCREMENT,
    title VARCHAR(140) NOT NULL,
    short_description VARCHAR(350) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    team_size INT NOT NULL,
    status ENUM('DRAFT','OPEN_FOR_MEMBERS','TEAM_FULL','IN_PROGRESS','COMPLETED','ARCHIVED') NOT NULL DEFAULT 'DRAFT',
    owner_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (project_id),
    KEY idx_project_owner (owner_id),
    KEY idx_project_status (status),
    KEY idx_project_category (category),
    KEY idx_project_title (title),
    CONSTRAINT fk_project_owner FOREIGN KEY (owner_id) REFERENCES student(student_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS project_skill (
    id BIGINT NOT NULL AUTO_INCREMENT,
    project_id BIGINT NOT NULL,
    skill_id BIGINT NOT NULL,
    skill_type ENUM('REQUIRED','PREFERRED') NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_project_skill (project_id, skill_id, skill_type),
    KEY idx_project_skill_project_id (project_id),
    KEY idx_project_skill_skill_id (skill_id),
    CONSTRAINT fk_project_skill_project FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE,
    CONSTRAINT fk_project_skill_skill FOREIGN KEY (skill_id) REFERENCES skill(skill_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS team_member (
    id BIGINT NOT NULL AUTO_INCREMENT,
    project_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    role ENUM('TEAM_LEAD','BACKEND_DEVELOPER','FRONTEND_DEVELOPER','UI_UX_DESIGNER','DATABASE_DEVELOPER','TESTER','MEMBER') NOT NULL DEFAULT 'MEMBER',
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_team_member_project_student (project_id, student_id),
    KEY idx_team_member_project_id (project_id),
    KEY idx_team_member_student_id (student_id),
    CONSTRAINT fk_team_member_project FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE,
    CONSTRAINT fk_team_member_student FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS request (
    request_id BIGINT NOT NULL AUTO_INCREMENT,
    project_id BIGINT NOT NULL,
    from_student_id BIGINT NOT NULL,
    to_student_id BIGINT NOT NULL,
    status ENUM('PENDING','ACCEPTED','REJECTED','WITHDRAWN') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (request_id),
    UNIQUE KEY uk_request_project_student (project_id, from_student_id, to_student_id),
    KEY idx_request_project (project_id),
    KEY idx_request_to_student (to_student_id),
    KEY idx_request_status (status),
    CONSTRAINT fk_request_project FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE,
    CONSTRAINT fk_request_from_student FOREIGN KEY (from_student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_request_to_student FOREIGN KEY (to_student_id) REFERENCES student(student_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS milestone (
    milestone_id BIGINT NOT NULL AUTO_INCREMENT,
    project_id BIGINT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    due_date DATE,
    status ENUM('NOT_STARTED','IN_PROGRESS','COMPLETED','BLOCKED') NOT NULL DEFAULT 'NOT_STARTED',
    progress_percentage INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (milestone_id),
    KEY idx_milestone_project (project_id),
    KEY idx_milestone_due_date (due_date),
    KEY idx_milestone_status (status),
    CONSTRAINT fk_milestone_project FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS activity_log (
    activity_id BIGINT NOT NULL AUTO_INCREMENT,
    project_id BIGINT NOT NULL,
    student_id BIGINT DEFAULT NULL,
    activity_type VARCHAR(100) NOT NULL,
    message VARCHAR(500) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (activity_id),
    KEY idx_activity_project (project_id),
    KEY idx_activity_student (student_id),
    KEY idx_activity_created_at (created_at),
    CONSTRAINT fk_activity_project FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE,
    CONSTRAINT fk_activity_student FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Optional: example seed values for the core skill catalog.
INSERT INTO skill (skill_name) VALUES
  ('Java'),('Spring Boot'),('MySQL'),('React'),('HTML'),('CSS'),('JavaScript'),('Python'),('Figma'),('Git'),('Docker')
ON DUPLICATE KEY UPDATE skill_name = skill_name;
