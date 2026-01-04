## Testing

This project was developed using a Test Driven Development (TDD) approach to ensure reliability and maintainability.

### TDD Process
- **Red-Green-Refactor Cycle**: For each new feature or bug fix, tests were written first (red), then code was implemented to pass the tests (green), followed by refactoring for clarity and efficiency.
- **RSpec and Rails Test Frameworks**: The application uses RSpec (for the custom gem) and Rails' built-in test framework for models, controllers, and integration tests.

### Testing Mechanisms
- **Model Tests**: Validate business logic, associations, and validations for `User`, `Project`, `Task`, and `Priority` models. (See `spec/models/` and `test/models/`)
- **Controller Tests**: Ensure correct responses and actions for all controllers. (See `spec/controllers/` and `test/controllers/`)
- **Feature/Integration Tests**: Simulate user interactions and verify end-to-end functionality. (See `spec/features/` and `test/integration/`)
- **Custom Gem Tests**: The `taskflows_utils` gem includes comprehensive RSpec tests for the priority scoring algorithm. (See `taskflows_utils/spec/priority_scoring_spec.rb`)

### Evidence of Testing
- Test files are located in the `spec/` and `test/` directories.
- Example command to run all tests:
	- Rails: `bin/rails test`
	- RSpec (for gem): `cd taskflows_utils && bundle exec rspec`
- Test results are output to the console and can be found in `test_results.txt` and `spec_results.json`.

### Example: Priority Scoring Test (RSpec)
```ruby
describe TaskflowsUtils::PriorityScoring do
	it "gives higher score to more important tasks" do
		scorer = described_class.new
		high = scorer.score(deadline: Date.today + 1, importance: 5, effort_hours: 2)
		low = scorer.score(deadline: Date.today + 1, importance: 1, effort_hours: 2)
		expect(high).to be > low
	end
end
```

### Example: Rails Model Test
```ruby
test "should not save project without name" do
	project = Project.new
	assert_not project.save, "Saved the project without a name"
end
```

This rigorous testing approach ensures that all core features are covered and regressions are quickly detected during development.
## Continuous Integration and Delivery Strategies

Taskflows adopts modern Continuous Integration (CI) and Continuous Delivery (CD) practices to ensure code quality, rapid feedback, and reliable deployments.

### Continuous Integration (CI)
- **Automated Testing**: All code changes are automatically tested using the Rails and RSpec test suites. This helps catch regressions early and maintain high code quality.
- **Linting and Code Quality**: Tools like RuboCop and Brakeman are used to enforce coding standards and check for security vulnerabilities as part of the CI pipeline.
- **Pull Request Workflow**: Developers submit changes via pull requests, which trigger automated checks before merging into the main branch.

### Continuous Delivery (CD)
- **Automated Deployment**: The application is configured for seamless deployment to Heroku. On merging to the main branch, the latest code can be automatically deployed to the production environment.
- **Asset Precompilation**: Assets are precompiled during the deployment process to ensure optimal performance in production.
- **Database Migrations**: Database schema changes are applied automatically during deployment, ensuring the production database stays in sync with the codebase.

### Example CI/CD Workflow
1. Developer pushes code to GitHub.
2. GitHub Actions (or similar CI service) runs tests, linters, and security checks.
3. If all checks pass, code is merged into the main branch.
4. Deployment to Heroku is triggered, running migrations and precompiling assets.
5. Application is live with the latest changes.

### GitHub Repository

The source code and CI/CD configuration for Taskflows are available at:

- [GitHub Repository URL](https://github.com/MazeTech89/TaskFlows)

These strategies ensure that Taskflows remains robust, secure, and easy to update, supporting rapid development and reliable releases.

## Conclusion

### Key Learnings
Through the development of Taskflows, I gained hands-on experience with modern Ruby on Rails application architecture, including MVC design, RESTful APIs, and integration of custom gems. I also deepened my understanding of Test Driven Development (TDD), CI/CD pipelines, and cloud deployment using Heroku.

### Mastered Steps
- Setting up and configuring a Rails 8.1 project with PostgreSQL
- Implementing authentication, project/task/priority management, and dashboard features
- Designing and integrating a custom gem for priority scoring
- Writing and maintaining comprehensive tests using RSpec and Rails test framework
- Automating deployment and asset management for production

### Easiest Part
The easiest part was leveraging Rails conventions and generators to quickly scaffold models, controllers, and views, which accelerated the initial development process.

### Hardest Part
The most challenging aspect was designing and integrating the custom priority scoring algorithm as a reusable gem, ensuring it was well-tested and flexible for future enhancements. Setting up a robust CI/CD pipeline and troubleshooting deployment issues on Heroku also required careful attention.

### Challenges Faced
- Integrating and testing a custom gem within the Rails application
- Managing database migrations and schema changes during active development
- Ensuring compatibility between local and production environments (especially with asset compilation and environment variables)
- Debugging deployment errors and configuring Heroku for smooth releases

Overall, this project provided valuable experience in full-stack Rails development, automated testing, and modern deployment practices, preparing me for more complex application development in the future.

## Submission Links

Below are important links related to this application:

- **GitHub Repository:** [https://github.com/MazeTech89/TaskFlows](https://github.com/MazeTech89/TaskFlows)
- **Deployed Application:** [https://taskflows-cad-2c1f46bbd901.herokuapp.com/](https://taskflows-cad-2c1f46bbd901.herokuapp.com/)
- **Video Presentation:** [Video Link](https://your-video-link.com) <!-- Replace with actual video link if available -->

Please update these links with your actual repository, deployment, and presentation URLs as needed.
## Design Patterns Used

This project implements several classic and Rails-specific design patterns to ensure maintainability and clarity:

### 1. Model-View-Controller (MVC)
- **Functionality**: Separates business logic, user interface, and request handling.
- **Files**: All files in `app/models/`, `app/views/`, and `app/controllers/`.
- **Usage**: Core structure of the Rails application.

### 2. Service Object Pattern
- **Functionality**: Encapsulates business logic outside of models/controllers for single responsibility.
- **Files**: `app/services/` (if present), `taskflows_utils/lib/taskflows_utils/priority_scoring.rb`.
- **Usage**: Priority scoring and reusable business logic.

### 3. Helper/Decorator Pattern
- **Functionality**: Adds presentation logic for views without polluting models/controllers.
- **Files**: `app/helpers/application_helper.rb`, `projects_helper.rb`, `tasks_helper.rb`.
- **Usage**: Formatting, UI helpers, and view logic.

### 4. Scope Pattern (ActiveRecord Scopes)
- **Functionality**: Encapsulates common query logic for models.
- **Files**: `app/models/project.rb`, `app/models/task.rb`, `app/models/priority.rb`.
- **Usage**: Filtering, sorting, and querying records (e.g., `Task.completed`).

### 5. Observer Pattern (Callbacks)
- **Functionality**: Responds to changes in model state (e.g., after_create, before_save).
- **Files**: Model files in `app/models/` (e.g., `task.rb`, `project.rb`).
- **Usage**: Automatically updating timestamps, recalculating scores, or triggering side effects.

### 6. Strategy Pattern (Priority Scoring)
- **Functionality**: Allows interchangeable algorithms for scoring priorities.
- **Files**: `taskflows_utils/lib/taskflows_utils/priority_scoring.rb`, used in `task.rb`.
- **Usage**: Task priority calculation can be swapped or extended without changing the Task model logic.

These patterns provide a robust, maintainable, and extensible architecture for the Taskflows application.
# Taskflows: Project Management Application

Taskflows is a Ruby on Rails 8.1 application designed to streamline project and task management for teams and individuals. It provides a modern, web-based interface for organizing projects, assigning priorities, tracking tasks, and collaborating efficiently. The application leverages PostgreSQL for data storage and is ready for deployment on platforms like Heroku.

## Key Features
- Project and task tracking
- Priority management
- User authentication
- Dashboard overview
- Asset pipeline with modern JavaScript integration
- Ready for cloud deployment (Heroku)

## Getting Started
1. Install dependencies with `bundle install` and `yarn install` (if using JS assets).
2. Configure your database in `config/database.yml`.
3. Run database migrations: `rails db:migrate`.
4. Start the server: `bin/rails server`.

## Deployment
Taskflows is configured for easy deployment to Heroku, including PostgreSQL support and asset precompilation.

## Design

### User Interface (GUI)
Taskflows features a modern, responsive web interface built with Ruby on Rails views and ERB templates. The main GUIs include:
- **Dashboard**: Overview of projects, tasks, and priorities.
- **Projects Page**: List, create, and manage projects.
- **Tasks Page**: View, add, and update tasks within projects.
- **Priorities Page**: Manage task priorities.
- **User Authentication**: Sign up, login, and user management screens.

*Screenshots of the main GUIs can be added here to visually showcase the application.*

### Technologies Used
- **Server**: Ruby on Rails 8.1 (MVC framework), PostgreSQL (database)
- **Frontend**: ERB templates, HTML5, CSS3, JavaScript (importmap), Stimulus controllers
- **Assets**: Managed with Rails asset pipeline and Propshaft
- **Deployment**: Heroku-ready configuration

### RESTful API Endpoints
Taskflows follows RESTful conventions for its resources. Example endpoints include:

- `GET    /projects`           – List all projects
- `POST   /projects`           – Create a new project
- `GET    /projects/:id`       – Show a specific project
- `PATCH  /projects/:id`       – Update a project
- `DELETE /projects/:id`       – Delete a project

- `GET    /tasks`              – List all tasks
- `POST   /tasks`              – Create a new task
- `GET    /tasks/:id`          – Show a specific task
- `PATCH  /tasks/:id`          – Update a task
- `DELETE /tasks/:id`          – Delete a task

- `GET    /priorities`         – List all priorities
- `POST   /priorities`         – Create a new priority
- `GET    /priorities/:id`     – Show a specific priority
- `PATCH  /priorities/:id`     – Update a priority
- `DELETE /priorities/:id`     – Delete a priority

Authentication endpoints and additional routes are available for user management and dashboard features.


## Databases (Models)

This Rails application uses a PostgreSQL database with the following tables and relationships:

### Tables
- **users**: Stores user accounts (email, encrypted password, etc.)
- **projects**: Stores projects, each belonging to a user
- **tasks**: Stores tasks, each belonging to a project and optionally a priority
- **priorities**: Stores priority levels (e.g., High, Medium, Low)

### Relationships
- A **User** has many **Projects**
- A **Project** belongs to a **User** and has many **Tasks**
- A **Task** belongs to a **Project** and optionally to a **Priority**
- A **Priority** can be assigned to many **Tasks**

### Entity-Relationship Diagram (ERD)

```
┌────────┐     1    ┌──────────┐    1    ┌────────┐
│ User   │─────────>│ Project  │────────>│ Task   │
└────────┘          └──────────┘         └────────┘
		^                                    /
		|                                   /
		|                                  /
		└──────────────────────────────<───┘
								many                many
								(has_many)          (belongs_to)

Each Task optionally belongs to a Priority:

┌────────┐
│Priority│
└────────┘
		^
		|
		└──────<───┐
					 many
				 (has_many)
```

This structure supports user-specific projects, each with multiple tasks, and flexible priority assignment for task management.

## Implementation

Taskflows is organized using the MVC (Model-View-Controller) pattern provided by Ruby on Rails. Below is a concise description of the main functionalities, with the key files responsible for each.

### Functionalities and File Mapping

#### 1. Project Management
- **Description**: Create, view, update, and delete projects.
- **Controllers**: `projects_controller.rb`
- **Models**: `project.rb`
- **Views**: All files in `views/projects/`

#### 2. Task Management
- **Description**: Add, assign, update, and track tasks within projects.
- **Controllers**: `tasks_controller.rb`
- **Models**: `task.rb`
- **Views**: All files in `views/tasks/`

#### 3. Priority Management
- **Description**: Define and manage task priorities.
- **Controllers**: `priorities_controller.rb`
- **Models**: `priority.rb`
- **Views**: All files in `views/priorities/`

#### 4. Dashboard Overview
- **Description**: Display summary and analytics of projects and tasks.
- **Controllers**: `dashboard_controller.rb`
- **Views**: All files in `views/dashboard/`

#### 5. User Authentication
- **Description**: User registration, login, and management.
- **Controllers**: (e.g., `application_controller.rb`, Devise controllers if used)
- **Models**: `user.rb`
- **Views**: All files in `views/shared/` and authentication-related views

#### 6. Application Layout & Helpers
- **Description**: Shared layouts, navigation, and helper methods.
- **Helpers**: `application_helper.rb`, `projects_helper.rb`, `tasks_helper.rb`
- **Views**: All files in `views/layouts/` and `views/shared/`

### Models
- `project.rb`: Represents a project entity
- `task.rb`: Represents a task entity
- `priority.rb`: Represents task priority
- `user.rb`: Represents application users

### Controllers
- `projects_controller.rb`, `tasks_controller.rb`, `priorities_controller.rb`, `dashboard_controller.rb`, `application_controller.rb`

### Views
- Located in `views/` subfolders: `projects/`, `tasks/`, `priorities/`, `dashboard/`, `layouts/`, `shared/`

### Architectural Diagram

Below is a high-level architectural overview of Taskflows:

```
┌────────────┐      ┌──────────────┐      ┌────────────┐
│   Client   │ <--> │   Rails MVC  │ <--> │ PostgreSQL │
└────────────┘      └──────────────┘      └────────────┘
	│                  │
	│                  └─ Asset Pipeline (Propshaft, JS, CSS)
	│
	└─ Deployed on Heroku (or other cloud platforms)
```

**Services/Tools Used:**
- Ruby on Rails 8.1
- PostgreSQL
- Propshaft (asset pipeline)
- Importmap, Stimulus (JavaScript)
- Heroku (deployment)



## License
This project is open source and available under the MIT License.

## References

The following resources were consulted and utilized during the development of Taskflows:

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Rails API Documentation](https://api.rubyonrails.org/)
- [Heroku Dev Center](https://devcenter.heroku.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [RSpec Documentation](https://rspec.info/documentation/)
- [Brakeman Security Tool](https://brakemanscanner.org/)
- [RuboCop Documentation](https://docs.rubocop.org/)
- [StimulusJS Handbook](https://stimulus.hotwired.dev/)
- [Propshaft Documentation](https://github.com/rails/propshaft)

Additional references, tutorials, and Stack Overflow discussions were also used as needed to address specific implementation challenges.
