# Student Project Team Finder

Student Project Team Finder is a full-stack academic collaboration platform for discovering projects, finding skill-aligned teammates, managing invitations, and tracking team milestones. It has a Bootstrap 5 frontend and a Java 17 / Spring Boot 3 REST API backed by MySQL 8.

## What is included

- JWT authentication with BCrypt password hashes and role-based API protection.
- Student profiles with skills, proficiency levels, interests, availability, and a completion indicator.
- Project creation, search, filtering, detailed views, owner-only editing, and archiving.
- Explainable matching: 80% required skills, 15% preferred skills, 5% interest/category alignment.
- Invitation workflow, duplicate prevention, team-size enforcement, and member roles.
- Milestones, project progress, activity feed, student dashboard, and administrator dashboard.
- Seed data, unit tests for matching, OpenAPI/Swagger, a Postman collection, `.env.example`, and a Git-ready ignore file.

## Repository layout

```text
student-project-team-finder/
├── backend/                         Spring Boot REST API
│   ├── src/main/java/edu/teamfinder/
│   │   ├── config/ security/ entity/ repository/
│   │   ├── dto/ mapper/ service/ controller/ exception/
│   ├── src/main/resources/application.yml
│   └── src/test/java/.../MatchingServiceTest.java
├── frontend/                        Static Bootstrap 5 web client
│   ├── assets/css/app.css
│   ├── assets/js/app.js
│   └── *.html                       Landing, student, team, and admin pages
├── postman/                         Importable API collection
├── .env.example
├── .gitignore
└── README.md
```

## Prerequisites (Windows)

1. Install JDK 17 or newer and set `JAVA_HOME`.
2. Install MySQL Server 8 and ensure it is running on port `3306`.
3. Install Maven 3.9+ and ensure `mvn -version` works in PowerShell.
4. Install Node.js only if you want the simple static frontend server below.

## Configure the database and environment

Create an application account in MySQL Workbench (or use your local development account):

```sql
CREATE DATABASE IF NOT EXISTS student_team_finder
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'teamfinder_app'@'localhost' IDENTIFIED BY 'change_me';
GRANT ALL PRIVILEGES ON student_team_finder.* TO 'teamfinder_app'@'localhost';
FLUSH PRIVILEGES;
```

Copy `.env.example` to `.env`, choose a long random `JWT_SECRET`, then set the values in the current PowerShell session. Spring Boot reads environment variables; it does not load `.env` automatically.

```powershell
$env:DB_HOST = 'localhost'
$env:DB_PORT = '3306'
$env:DB_NAME = 'student_team_finder'
$env:DB_USERNAME = 'teamfinder_app'
$env:DB_PASSWORD = 'change_me'
$env:JWT_SECRET = 'replace-this-with-a-long-random-development-secret-of-32-or-more-characters'
$env:CORS_ALLOWED_ORIGINS = 'http://localhost:5500,http://127.0.0.1:5500'
```

Hibernate creates/updates the schema at startup for local development. For a production deployment, change `spring.jpa.hibernate.ddl-auto` to `validate` and manage schema changes with migrations.

## Run the backend

```powershell
cd backend
mvn clean test
mvn spring-boot:run
```

The API starts at `http://localhost:8080`. Swagger UI is available at `http://localhost:8080/swagger-ui.html`.

## Run the frontend

Open a second PowerShell terminal from the repository root:

```powershell
npx serve frontend -l 5500
```

Then browse to `http://localhost:5500`. The frontend expects the API at `http://localhost:8080/api`. To point a local browser session at a different API host, run this once in DevTools:

```js
localStorage.setItem('teamfinder.apiBase', 'https://your-api.example/api')
```

Reload the page after changing it.

## Development-only seed accounts

| Role | Email | Password |
| --- | --- | --- |
| Student | `arjun@campus.dev` | `CampusPass!2026` |
| Administrator | `admin@campus.dev` | `CampusPass!2026` |

All sample credentials are for local development only. Change/remove seed credentials before any non-local deployment.

## Matching rules

The matching service ranks only students who are available or limited, are not already in the project team, and do not have a pending invitation for the project.

| Factor | Weight |
| --- | ---: |
| Required skill coverage | 80% |
| Preferred skill coverage | 15% |
| Category appears in student interests | 5% |

The API returns both the percentage and a readable explanation plus matching/missing skills. A candidate with Java and React for a project requiring Java + Spring Boot and preferring React, whose interests include the project category, receives `60%` (40 + 15 + 5).

## API map

All endpoints use JSON. Send `Authorization: Bearer <token>` after logging in.

| Area | Key endpoints |
| --- | --- |
| Authentication | `POST /api/auth/register`, `POST /api/auth/login`, `POST /api/auth/logout` |
| Student profiles | `GET/PUT /api/students/me`, `GET /api/students`, `GET /api/students/{id}`, `GET /api/skills` |
| Projects | `GET/POST /api/projects`, `GET/PUT /api/projects/{id}`, `POST /api/projects/{id}/archive` |
| Matching & invitations | `GET /api/projects/{id}/candidates`, `POST /api/projects/{id}/invitations`, `GET /api/invitations`, `POST /api/invitations/{id}/accept|reject|withdraw` |
| Team & workspace | `PATCH /api/projects/{id}/members/{memberId}/role`, `GET /api/projects/{id}/workspace`, `POST/PUT/DELETE /api/projects/{id}/milestones...` |
| Dashboard | `GET /api/dashboard` |
| Admin (ADMIN role) | `GET /api/admin/stats`, `GET /api/admin/users`, `PATCH /api/admin/users/{id}/availability`, `GET /api/admin/projects`, `PATCH /api/admin/projects/{id}/status` |

Import `postman/Student-Project-Team-Finder.postman_collection.json` into Postman to exercise the most important flows. The login request stores the token collection variable automatically.

## Design and implementation notes

- Public registration creates student accounts only. Administrator account creation is deliberately not public; the development admin is seeded, and production admins should be provisioned through a controlled administrative process. This prevents an arbitrary visitor from self-assigning elevated privileges.
- Logout is client-side token removal because the JWT API is stateless. For production revocation, add a server-side token deny-list or short-lived access tokens plus refresh-token rotation.
- A project owner is automatically added as `TEAM_LEAD`. Team size includes that owner.
- Project status becomes `TEAM_FULL` automatically when an accepted invitation reaches capacity.
- The frontend is deliberately framework-free to meet the requested HTML/CSS/JavaScript + Bootstrap stack; it communicates only with the REST API.

## Verification checklist

The repository includes an automated unit test for weighted matching and static frontend syntax can be checked with `node --check frontend/assets/js/app.js`.

Run the following locally after installing the listed prerequisites:

- [ ] `mvn clean test` passes, including weighted matching tests.
- [ ] Registration and login issue a JWT and store only BCrypt password hashes.
- [ ] Student token cannot call `/api/admin/**`; admin token can.
- [ ] Profile edits add/update/remove skills and update completion.
- [ ] Project create, edit, archive, search, filtering, and detail routes work.
- [ ] Candidate percentage, matching skills, missing skills, and exclusions behave as documented.
- [ ] Invitations accept/reject/withdraw correctly and team-size cap is enforced.
- [ ] Milestone create/update/delete changes project progress and activity.
- [ ] Admin tables search/filter and moderation actions work.
- [ ] Landing, forms, cards, navigation, and tables remain usable at mobile width.

### Local delivery verification

The available authoring environment did not have a JDK or Maven installed, so a live Spring compilation/database run could not be executed here. The frontend JavaScript syntax check completed successfully. Before relying on the application, run the checklist above in a Java 17 + MySQL 8 environment.
#   T e a m F i n d e r  
 