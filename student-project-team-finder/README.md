# Student Project Team Finder

Student Project Team Finder is a full-stack academic collaboration platform for discovering projects, finding skill-aligned teammates, managing invitations, and tracking team milestones. It features a Bootstrap 5 frontend and a Java 17 / Spring Boot 3 REST API backed by MySQL 8.

## What is Included

- JWT authentication with BCrypt password hashes and role-based API protection.
- Student profiles with skills, proficiency levels, interests, availability, and a completion indicator.
- Project creation, search, filtering, detailed views, owner-only editing, and archiving.
- Explainable matching: 80% required skills, 15% preferred skills, 5% interest/category alignment.
- Invitation workflow, duplicate prevention, team-size enforcement, and member roles.
- Milestones, project progress, activity feed, student dashboard, and administrator dashboard.
- Seed data, unit tests for matching, OpenAPI/Swagger, a Postman collection, `.env.example`, and a Git-ready ignore file.

## Repository Layout

```text
student-project-team-finder/
├── backend/                        Spring Boot REST API
│   ├── src/main/java/edu/teamfinder/
│   │   ├── config/ security/ entity/ repository/
│   │   ├── dto/ mapper/ service/ controller/ exception/
│   │   ├── src/main/resources/application.yml
│   └── src/test/java/.../MatchingServiceTest.java
├── frontend/                       Static Bootstrap 5 web client
│   ├── assets/css/app.css
│   ├── assets/js/app.js
│   └── *.html                       Landing, student, team, and admin pages
├── postman/                        Importable API collection
├── .env.example
├── .gitignore
└── README.md
