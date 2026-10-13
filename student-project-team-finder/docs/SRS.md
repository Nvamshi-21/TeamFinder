# Software Requirements Specification (SRS)

## 1. Introduction

### 1.1 Purpose
The Student Project Team Finder platform helps university students discover academic projects, evaluate teammate fit using skill-based matching, manage project invitations, and track milestone-driven progress in a shared team workspace.

The system is designed for academic collaboration and is intended to be used by both students and administrators inside a university environment.

### 1.2 Scope
This project supports:
- Student registration and login
- Profile management, skills, interests, and availability
- Project creation, filtering, and matching
- Invitation-based team formation
- Team workspace and milestone tracking
- Administrator moderation and reporting

### 1.3 Product Goals
The goals of the system are to:
- reduce the friction of finding a suitable team for academic projects
- make project-team matching explainable and transparent
- help students understand each other through profiles and skill evidence
- support project progress tracking throughout the semester
- allow administrators to monitor active projects and manage abuses or poor-quality posts

### 1.4 Assumptions
- The application is intended for local development and university lab use.
- MySQL 8 is the target relational database.
- Students and admin users authenticate with JWT tokens.
- The frontend is a static HTML/CSS/JavaScript client communicating with the REST API.
- The platform is not a replacement for institutional LMS tooling or a general-purpose social network.

## 2. Overall Description

### 2.1 User Roles
The system includes two primary roles:
1. Student
2. Administrator

Students can create projects, update profiles, search for teammates, accept or reject invitations, and collaborate in team workspaces. Administrators can monitor platform activity and moderate users or projects.

### 2.2 Operating Environment
- Java 17+
- Spring Boot 3
- Spring Security
- Spring Data JPA / Hibernate
- MySQL 8
- HTML5, CSS3, JavaScript, Bootstrap 5
- Maven

### 2.3 Key Constraints
- Student accounts must never be able to access administrator features.
- Passwords must never be stored in plain text.
- Projects cannot exceed team size limits.
- Invitations must prevent duplicates and over-capacity issues.
- Matching must be explainable and based on a documented scoring model.

## 3. Functional Requirements

### 3.1 User Registration and Login
- Users must be able to register as students.
- Admin accounts are seeded and not publicly self-service.
- Users must log in using email and password.
- JWT tokens are returned on successful login.
- Passwords are hashed using BCrypt.
- Invalid credentials and invalid input must be handled with clear error messages.

### 3.2 Student Profile Management
- Students must be able to view and update profile information.
- Students are able to add, edit, and remove skills.
- Each skill includes a proficiency level: Beginner, Intermediate, Advanced.
- Students can define interests and project domains.
- Students can set availability for team participation.
- Students can see a progress indicator showing profile completeness.

### 3.3 Project Creation and Discovery
- Students can create, view, search, filter, and edit project posts.
- Projects include title, description, category, required skills, preferred skills, and team size.
- Project status must be one of: Draft, Open for Members, Team Full, In Progress, Completed, Archived.
- Only the project owner can edit or archive their project.
- Users can search and filter projects by category, skill, branch, status, and availability.

### 3.4 Matching Engine
The matching engine must:
- compare project skills against student skills
- compute a match percentage from 0 to 100
- give stronger weight to required skills than preferred skills
- consider availability and role constraints
- exclude users already on the project team
- exclude students with a pending request to the same project
- display human-readable explanations of the score

The specified scoring model is:
- Required skill coverage: 80%
- Preferred skill coverage: 15%
- Interest/category alignment: 5%

### 3.5 Team Requests and Invitations
- Project owners can send invitations to matched students.
- Students can accept or reject invitations.
- Duplicate invitations and duplicate memberships are prevented.
- Team size controls must be enforced.
- When the team reaches team size, the project status updates to Team Full.
- Member roles such as Team Lead, Backend Developer, Frontend Developer, UI/UX Designer, Database Developer, Tester, and Member must be supported.

### 3.6 Project Progress Tracking
- Team members can create milestones.
- Milestones have title, description, due date, status, and progress percentage.
- Progress for a project is computed from milestone state.
- Activity logs record membership and milestone changes.
- Team dashboard displays members, roles, milestones, and status.

### 3.7 Admin Panel
Administrators can:
- view all users
- search/filter users
- update availability for moderation
- view all projects and manage their status
- archive or remove inappropriate content
- inspect platform statistics such as total students, active projects, open projects, teams formed, pending requests, and skills distribution

## 4. Non-Functional Requirements

### 4.1 Security
- JWT-based authentication
- BCrypt password hashing
- Role-based access control
- CORS configuration for frontend origins
- Environment-variable configuration for secrets and database credentials

### 4.2 Usability
- Clean, professional academic UI
- Responsive desktop, tablet, and mobile layouts
- Keyboard-accessible forms and visible focus states
- Clear empty states and human-readable labels

### 4.3 Reliability
- Validation for required fields and business rules
- Global exception handling with clear API error responses
- Duplicate prevention and safe cascading rules
- Meaningful database indexes for common search fields

### 4.4 Maintainability
- Layered architecture: controller, service, repository, entity, dto, mapper, security, exception, config, validation
- OpenAPI/Swagger documentation
- Structured seeding for development data
- Unit tests for critical business logic

## 5. External Interfaces

### 5.1 REST API
The application exposes REST endpoints under /api for authentication, dashboards, students, projects, teams, and admin flows.

### 5.2 Frontend Client
The frontend is a static Bootstrap-based interface that consumes the REST API from the configured API base URL.

### 5.3 Database
The application stores data in MySQL 8 using JPA entities and repository interfaces.

## 6. Acceptance Criteria
The product is accepted when:
- a student can register and log in successfully
- JWT auth works and role restriction is enforced
- profile and skill management works end-to-end
- project creation and project browsing works
- candidate matching returns consistent scores and explanations
- invitations and team membership rules are enforced
- milestones and team workspace progress work correctly
- admin moderation dashboards are operable
- the app remains usable on mobile screens

## 7. Traceability Notes
This SRS is aligned with the backend entity model and frontend workflow requirements documented in the project brief and the generated repository structure. The implementation should stay consistent with the database model, role restrictions, and matching rules defined in the project specification.
