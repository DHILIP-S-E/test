# LifeOS - Unified Productivity & Finance Application Architecture

This document describes the architectural decisions, design patterns, and structure of the **LifeOS** application.

## 1. High-Level Architecture

The system is designed as a **Monorepo** with a clear separation of concerns:

-   **Backend**: A RESTful API built with **FastAPI** (Python), serving as the single source of truth for business logic and data persistence. It interacts with the **PostgreSQL** database.
-   **Mobile**: A cross-platform **Flutter** application for Android and iOS. It uses a **Repository Pattern** to abstract data sources (API vs Local DB).
-   **Database**: A **PostgreSQL** database schema managed via **Supabase**. Row Level Security (RLS) is used for data isolation.

## 2. Backend Architecture (FastAPI)

The backend follows **Clean Architecture** principles, organizing code by domain and layer.

### Layers:
1.  **Presentation Layer (API)**: Handles HTTP requests, validation, and routing. Uses Pydantic models for request/response schemas.
    -   Located in `app/api/`
2.  **Application Layer (Services)**: Contains the core business logic. It orchestrates data flow between repositories and the API layer.
    -   Located in `app/services/`
3.  **Domain Layer (Models)**: Defines the core entities and business rules. SQLAlchemy models represent the database tables.
    -   Located in `app/models/`
4.  **Infrastructure Layer (Core/DB)**: Handles external concerns like database connections, configuration, and security.
    -   Located in `app/core/` and `app/db/`

### Key Design Patterns:
-   **Dependency Injection**: Used throughout the application to inject dependencies (e.g., database sessions, services) into route handlers. This enhances testability and modularity.
-   **Repository Pattern**: Abstracts data access logic from business logic. (Note: In simple FastAPI apps, services often interact with SQLAlchemy sessions directly, but we aim for abstraction).
-   **DTO (Data Transfer Object)**: Pydantic schemas serve as DTOs, ensuring strict validation of input/output data.

## 3. Mobile Architecture (Flutter)

The mobile app follows a **Feature-First** structure, where code is organized by feature (e.g., `auth`, `finance`, `tasks`) rather than by layer (e.g., `views`, `controllers`).

### Layers within Features:
1.  **Presentation Layer**: Widgets and UI logic. Uses **Riverpod** for state management.
    -   `lib/features/<feature>/presentation/`
2.  **Domain Layer**: Pure Dart classes representing entities and business logic. Independent of Flutter or external libraries.
    -   `lib/features/<feature>/domain/`
3.  **Data Layer**: Implementations of repositories and data sources (API clients, local DB).
    -   `lib/features/<feature>/data/`

### State Management:
-   **Riverpod**: Chosen for its compile-time safety, testability, and separation from the widget tree.
-   **GoRouter**: For declarative routing and deep linking.

## 4. Database Schema

The database is normalized to 3NF (Third Normal Form) to reduce redundancy.

-   **Users**: Central identity table.
-   **Finance Module**: Tables for `transactions`, `budgets`, `goals`, `achievements`.
-   **Tasks Module**: Tables for `tasks`, `projects`, `executions`, `alarms`.
-   **Cross-Module**: Link tables like `transactions.linked_task_id`.

**Security**: Row Level Security (RLS) ensures users can only access their own data.

## 5. Security & Authentication

-   **Authentication**: JSON Web Tokens (JWT) using OAuth2 password flow.
-   **Authorization**: Role-Based Access Control (RBAC) implemented via scopes in JWT.
-   **Data Protection**: Sensitive data (passwords) hashed using Bcrypt. HTTPS enforcement.
-   **Input Validation**: Strict validation using Pydantic and proper sanitization.

## 6. Deployment & DevOps

-   **Docker**: Both backend and frontend (for web build) are containerized.
-   **CI/CD**: GitHub Actions pipeline for linting, testing, and building artifacts.
-   **Environment Config**: 12-factor app principles, using `.env` files for configuration.
