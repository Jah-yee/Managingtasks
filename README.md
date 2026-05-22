# ManagingTasks

A personal task-management web application built with **ASP.NET Core Razor Pages**, **Entity Framework Core (EF Core)**, and **SQLite** for storage, with secure authentication powered by **ASP.NET Core Identity**.

This project runs **fully in Docker** for easy local demonstration.

---

## 1. High-Level Architecture & Flow

The system follows a classic layered MVC/Razor Page architecture connected to a persistent SQLite database.

```text
+-------------------------------------------------------------+
|                       CLIENT BROWSER                        |
+-------------------------------------------------------------+
                               |
                               | (HTTP Request)
                               v
+-------------------------------------------------------------+
|             ASP.NET CORE WEB HOST (DOCKER)                  |
+-------------------------------------------------------------+
|                                                             |
|   1. Authentication Middleware (ASP.NET Core Identity)       |
|      +---> [Anonymous] -> Redirect to /Identity/Account/Login|
|      +---> [Authenticated] -> Route to /Tasks/Index          |
|                                                             |
|   2. Razor Page Backend (/Pages/Tasks/Index.cshtml.cs)      |
|      * Pulls current User ID from Claims                     |
|      * Requests user-specific tasks from DB context          |
|                                                             |
|   3. Entity Framework Core (ApplicationDbContext)           |
|      * Translates LINQ queries to SQL commands               |
|                                                             |
+-------------------------------------------------------------+
                               |
                               | (SQL Query)
                               v
+-------------------------------------------------------------+
|                     PERSISTENT DATABASE                     |
+-------------------------------------------------------------+
|                      SQLite (app.db)                        |
|                      [Tasks Table]                          |
|                      [AspNetUsers Table]                    |
+-------------------------------------------------------------+
```

### Flow Breakdown:
1.  **Request Authentication**: User visits the application. The middleware stack checks if the session is authenticated. If anonymous, they are redirected to login/register under the Identity Area.
2.  **Razor Page Controller Action**: Once authenticated, the user is redirected to `/Tasks/Index` where the back-end retrieves tasks associated with the user's logged-in identity from `ApplicationDbContext`.
3.  **ORM & Storage Operations**: Entity Framework translates C# queries to SQL queries and performs operations on `app.db`.
4.  **Database Persistence**: `app.db` is persistently mounted on the host machine to ensure no data is lost when Docker containers are stopped or rebuilt.

---

## 2. Technologies Used
*   **ASP.NET Core 8.0**
*   **Entity Framework Core 7.0**
*   **SQLite**
*   **ASP.NET Core Identity**
*   **Docker & Shell Automation**

---

## 3. How to Run the Demo via Docker (Ubuntu)

No host dependencies (such as the .NET SDK or SQLite) are required. Everything—including database migrations—runs inside isolated Docker containers!

### Step 1: Make Scripts Executable
In your terminal, navigate to the project directory and run:
```bash
chmod +x run.sh stop.sh
```

### Step 2: Start the Demo
To apply database migrations, build the container, and start the app in the background, run:
```bash
./run.sh
```
The application will launch and be available on:
👉 **URL**: [http://localhost:5182](http://localhost:5182)

### Step 3: Monitor Logs
To watch the real-time application server log output inside Docker, run:
```bash
docker logs -f managingtasks-app
```

### Step 4: Stop the Demo
To cleanly stop and remove the application container, run:
```bash
./stop.sh
```

---

## 4. Identified Bugs & Missing Things

To complete the application, the following identified issues must be fixed:

1.  **Static Data Bug in `Index.cshtml`**: The tasks table currently prints hardcoded string literals (e.g. `"Title"`, `"Admin"`, `"Description"`) instead of dynamic C# properties (e.g. `@task.Title`, `@task.Description`).
2.  **Missing `_ViewImports.cshtml` / `_ViewStart.cshtml` in `Pages`**: Because Razor Pages are inside `/Pages` and their imports are inside `/Views`, the tag helpers like `asp-page`, `asp-for` are dysfunctional, and the pages do not inherit the default CSS layout.
3.  **Broken Table Columns in `Index.cshtml`**: The task table has 6 column headers but renders 7 data cells per row, creating a misaligned table.
4.  **Empty `TaskPriority.cs`**: The file is completely empty and lacks enum definitions.
5.  **Timestamp Bug in `Create.cshtml.cs`**: `CreatedAt` and `UpdatedAt` dates are not populated during new task creation.