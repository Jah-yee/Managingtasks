# ManagingTasks

A personal task management web application built with ASP.NET Core and Entity Framework Core.

Users can register, log in, create tasks, update task status, and manage their own task list securely.

---

## Features

- User registration and login
- Authentication with ASP.NET Core Identity
- Create, edit, and delete tasks
- Task status management
- Each user can access only their own tasks
- SQLite database with Entity Framework Core
- Validation for required fields

---

## Technologies

- ASP.NET Core Razor Pages
- Entity Framework Core
- SQLite
- ASP.NET Core Identity
- C#

---

## Database

The application uses SQLite (`app.db`) with Entity Framework Core migrations.

Main tables:
- AspNetUsers
- Tasks

---

## Running the Project

### 1. Clone the repository

```bash
git clone <your-repository-url>
cd Managingtasks