# Taskflows — Video Presentation & Demo Script (≤10 minutes)

Use this as your **recording script + checklist** for the Cloud Application Development module video deliverable.

> Replace placeholders like **<YOUR GITHUB URL>** before recording.

---

## 1) What you must cover (grading alignment)

### Learning outcomes coverage
- **LO1 (framework & patterns):** Rails MVC, RESTful routes, and one design pattern choice.
- **LO2 (CRUD SaaS):** Create/Read/Update/Delete across your core entities.
- **LO3 (TDD & tests):** Show tests running + explain how you used Red–Green–Refactor.
- **LO4 (CI/CD):** Show your automated checks (tests + lint + security scans) and how they run on push/PR.
- **LO5 (deployment):** Show the live deployed app and briefly compare it to local.

### Assessment criteria mapping (what to explicitly demonstrate)
- **Report & video (20%)**: Clear walkthrough, deployed URL demo, key highlights, problem workarounds.
- **Front-end design (20%)**: Layouts/partials, Bootstrap styling, dashboards/views.
- **Back-end design (20%)**: REST CRUD, validations, database relationships.
- **Library & testing (20%)**: Meaningful library + TDD evidence (unit → integration).
- **CI/CD & deployment (20%)**: GitHub Actions checks + cloud deployment proof.

---

## 2) Video structure (timestamped run-of-show)

### 0:00–0:20 — Title + context
Say:
- “Hi, I’m <NAME>. This is **Taskflows**, my Rails SaaS project for Cloud Application Development.”
- “Repository: <YOUR GITHUB URL>”
- “Deployed URL: https://taskflows-cad-2c1f46bbd901.herokuapp.com/”

Show on screen:
- Browser tab with deployed app open.

### 0:20–1:20 — Motivation + idea (1–2 minutes total with next section)
Say:
- “Taskflows is a lightweight project/task manager. The goal is to manage projects, tasks, and priorities, and to surface what to do next using a priority scoring approach.”
- “It’s a SaaS-style CRUD app built with Rails 8.1 and PostgreSQL.”

### 1:20–2:10 — High-level design (LO1)
Show on screen (quick, do not code-dive):
- Routes overview to prove REST resources:
  - `root` dashboard
  - `projects`, `tasks`, `priorities`
  - Authentication routes

Say:
- “This follows Rails MVC. Controllers handle requests, models handle data/validations, views use layouts/partials.”
- “Key routes are RESTful and support full CRUD for the main resources.”

Optional (10 seconds):
- Mention patterns used: MVC + service/library extraction for business logic.

### 2:10–3:10 — The hardest part + how you solved it
Pick ONE “hardest part” story and keep it concrete.

Recommended story (fits this codebase): **custom priority scoring library + testability**
Say:
- “The hardest part was building a reliable priority scoring algorithm and integrating it cleanly.”
- “I solved it by extracting it into a reusable library (a custom gem), designing the API to be deterministic in tests by allowing a fixed `current_date`, and writing RSpec tests for edge cases like overdue deadlines and nil deadlines.”

If relevant to your setup, you can also mention:
- “I hit PostgreSQL permission issues during testing/migrations and fixed it by aligning DB ownership and privileges.”

### 3:10–7:30 — Live demonstration (core CRUD + UI)
Record from the **deployed URL**.

#### A) Authentication (Devise)
Do:
- If you’re logged out: use the top navbar links **“Sign Up”** or **“Login”**.
- If you’re logged in: point out **“Logout”** exists in the navbar.

Say:
- “Authentication is handled via Devise; users can sign up and sign in.”

#### B) Dashboard (overview)
Do:
- In the top navbar, click **“Dashboard”**.
- Point out the cards: **Total Tasks**, **Completed**, **Pending**, **Overdue**.
- Point out the **Overall Completion Rate** progress bar.
- Point out the charts (Chartkick): **Tasks by Project**, **Task Completion Trend (Last 7 Days)**.

Say:
- “The dashboard provides an overview to support quick decision-making.”

#### C) Projects (CRUD)
Do:
- In the top navbar, click **“Projects”**.
- Click **“New Project”**.
- Enter a name and optional description, then click **“Save Project”**.
- **View** its details.
- On the Projects list, use the **Show / Edit / Delete** buttons for one row.
- If you open a project page, use **“Edit this project”** and **“Destroy this project”**.

Say:
- “Projects support full CRUD. Rails validations ensure required fields are present.”

Quick validation proof (10 seconds):
- Mention the validation briefly (e.g., name is required and has a minimum length). If you want to demonstrate it live, intentionally submit a too-short name and show the save failing.

#### D) Tasks (CRUD + nested create)
Do:
- In the top navbar, click **“Tasks”**.
- Optional (quick UI highlight): show the filter form labels **Search by Name / Project / Priority / Status / Due Date**, and the buttons **“Filter”** and **“Clear Filters”**.
- Click **“New Task”** (this button appears once you have at least one project).
- Fill **Task Name**, choose a **Project**, optionally set **Due date** and **Priority (Optional)**.
- Tick **“Mark as completed”** (optional), then click **“Create Task”**.
- Open the task using **“Show”**, then click **“Edit this task”** and update it (button becomes **“Update Task”**).
- Delete using the **“Delete”** button (either in the table or on the task show page).

Say:
- “Tasks can be created within a project context and managed via standard REST endpoints.”

#### E) Priorities (CRUD) + “meaningful library” behavior
Do:
- Open the priorities page (if it’s not in the navbar, type `/priorities` after your domain, e.g. `https://.../priorities`).
- Click **“New Priority”**, set **name** and **score**, then click **“Save Priority”**.
- Open one priority with **“Show”**, then click **“Edit”** to demonstrate update.
- Go back to **Tasks** and demonstrate library behavior by sorting using the query param:
  - add `?sort_by=priority_score` to the Tasks URL, e.g. `https://.../tasks?sort_by=priority_score`
  - explain that the ordering is computed via the custom gem.

Say:
- “The meaningful new library here is my custom gem `taskflows_utils`, which calculates a numeric priority score from deadline, importance, and effort. This helps rank tasks so the most urgent or overdue items surface first.”

If charts are in the dashboard:
- Mention `chartkick` (charts) and how it improves the UI/insight.

### 7:30–8:40 — Testing + TDD evidence (LO3)
Goal: show at least one test run and explain the approach.

Option 1 (fastest): show terminal running tests locally.
Do:
- Run Rails tests:
  - `bin/rails test`
- Run gem specs:
  - `cd taskflows_utils`
  - `bundle exec rspec`

Say:
- “I used a TDD workflow: write failing tests first, implement the feature, then refactor.”
- “There are Rails tests for models/controllers/system flows, plus RSpec tests for the custom gem.”

Option 2 (backup): open saved results files.
Do:
- Open `test_results.txt` / `spec_results.json` to show evidence.

### 8:40–9:30 — CI/CD strategy (LO4) + deployment proof (LO5)
Show on screen (pick 2 quick proofs):
- GitHub Actions workflow page (preferred), OR the workflow file in the repo.
- Mention checks: lint (RuboCop), security (Brakeman, bundler-audit, importmap audit), tests (Rails + system).

Say:
- “On each push/PR, CI runs linting, security scans, and tests against PostgreSQL.”
- “Deployment is to <Heroku / your chosen platform>. The deployed version matches the local features; the main difference is production configuration like environment variables and asset compilation.”

### 9:30–10:00 — Wrap-up
Say:
- “In summary, Taskflows meets the module requirements: Rails framework and patterns, full CRUD, tested with TDD, CI checks, and deployed publicly.”
- “If I had more time, I’d add <1–2 realistic improvements>.”

---

## 3) Click-by-click demo checklist (so you don’t miss anything)

Before recording:
- Confirm the deployed site loads: **https://taskflows-cad-2c1f46bbd901.herokuapp.com/**
- Have a test account ready (or sign up during video).
- Prepare 1–2 sample projects and 3–5 tasks.
- Keep the demo dataset small so you can CRUD quickly.

During recording (minimum set):
- Auth: sign in
- Dashboard: show overview
- Projects: create + edit + delete (or delete a temporary item)
- Tasks: create within a project + edit + delete
- Priorities: create/edit + show it impacts task ranking/score
- Testing: show at least one test command run (or show stored results)
- CI/CD: show GitHub Actions checks (or workflow file)
- Deployment: confirm you’re using deployed URL during demo

---

## 4) Recording instructions (simple + reliable)

### Recommended screen layout
- Left: Browser (deployed app)
- Right: Terminal (tests) or VS Code (workflow/test files)

### Audio / pacing tips
- Speak while you click (“Now I’m creating a project… now editing… now deleting”).
- Avoid deep code reading; focus on outcomes and requirements.
- Keep “hardest part” to 45–60 seconds.

### If the deployed site fails during recording
- Say: “The deployed instance is temporarily unavailable; I’ll demonstrate the same functionality locally.”
- Continue locally, but **re-record later** when the deployed site is up if your marking requires deployed URL proof.

---

## 5) Quick commands you can run during the video

Run Rails tests:
- `bin/rails test`

Run system tests:
- `bin/rails test:system`

Run the custom gem RSpec tests:
- `cd taskflows_utils`
- `bundle exec rspec`

Run the local CI script (optional, only if it’s fast on your machine):
- `bin/ci`

---

## 6) Placeholders to fill before submission

- GitHub repo URL: **<YOUR GITHUB URL>**
- Deployed URL: **https://taskflows-cad-2c1f46bbd901.herokuapp.com/**
- Video URL (if you host it): **<YOUR VIDEO URL>**

---

## 7) Suggested “future work” (pick 1–2 only)

- Add role-based access (admin vs user)
- Add task assignment to multiple users
- Add recurring tasks and reminders
- Improve analytics dashboards and filtering
