# LifeOS - Unified Productivity & Finance Application

**LifeOS** (working title) is a production-grade, unified application designed to help users manage their money and time in one seamless platform. It combines gamified finance management (**Paisa Quest**) with robust task management (**Iagis-Lite**) and provides cross-module insights.

## 🚀 Features

### **Module 1: Finance (Paisa Quest)**
-   **Gamified Expense Tracking**: Earn coins for logging expenses.
-   **Smart Goals**: Savings, Debt Payoff, Investment goals visualized as a virtual city.
-   **Budget Management**: AI-powered budget creation and alerts.
-   **Financial Education**: Bite-sized lessons and quizzes.
-   **AI Companion ("Artha")**: Conversational finance assistant.

### **Module 2: Tasks (Iagis-Lite)**
-   **Production-Grade Tasks**: Reliable OS-level alarms.
-   **Execution Tracking**: Track time spent on tasks for accurate billing/insights.
-   **Offline-First**: Full functionality without internet.
-   **Projects & Organization**: Group tasks, filter by priority/status.

### **Module 3: Unified Insights**
-   **Time vs Money Analytics**: Correlate spending with time usage.
-   **Actionable Recommendations**: AI-driven suggestions to improve habits.

## 🛠 Tech Stack

### **Backend (API)**
-   **Language**: Python 3.10+
-   **Framework**: FastAPI (High performance, easy to use)
-   **ORM**: SQLAlchemy + Pydantic (Data validation)
-   **Database**: PostgreSQL 15+ (via Supabase)
-   **Authentication**: JWT (JSON Web Tokens) + OAuth2
-   **Testing**: Pytest

### **Frontend (Mobile)**
-   **Framework**: Flutter 3.16+ / Dart 3.2+
-   **State Management**: Riverpod 2.0 (Compile-safe, testable)
-   **Navigation**: GoRouter (Deep linking support)
-   **Networking**: Dio (Robust HTTP client)
-   **Local Storage**: Drift (SQLite) for offline-first architecture
-   **UI/UX**: Custom Design System adhering to Material 3 guidelines

### **DevOps & Infrastructure**
-   **Containerization**: Docker & Docker Compose
-   **CI/CD**: GitHub Actions (planned)
-   **Monitoring**: Sentry (Error tracking), PostHog (Analytics)

## 📂 Project Structure

The project is organized as a monorepo:

```
life_os/
├── backend/        # FastAPI Application
│   ├── app/
│   │   ├── api/    # Route handlers
│   │   ├── core/   # Configuration, Security
│   │   ├── db/     # Database session & models
│   │   ├── services/ # Business logic
│   │   └── schemas/ # Pydantic DTOs
│   ├── tests/      # Unit & Integration tests
│   └── alembic/    # Database migrations
├── mobile/         # Flutter Application
│   ├── lib/
│   │   ├── core/   # Shared utilities, theme, errors
│   │   ├── features/ # Feature-based modules (auth, finance, tasks)
│   │   └── main.dart
│   └── test/       # Widget & Unit tests
├── database/       # Database Schema & SQL Scripts
└── docs/           # Architecture & Design Documents
```

## 🚀 Getting Started

### Prerequisites
-   Python 3.10+
-   Flutter SDK
-   Docker (optional, for local DB)
-   PostgreSQL (or Supabase account)

### Backend Setup
1.  Navigate to `backend/`:
    ```bash
    cd backend
    ```
2.  Create a virtual environment:
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate
    ```
3.  Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```
4.  Run the server:
    ```bash
    uvicorn app.main:app --reload
    ```

### Mobile Setup
1.  Navigate to `mobile/`:
    ```bash
    cd mobile
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the app:
    ```bash
    flutter run
    ```

## 📄 License
MIT License. See [LICENSE](LICENSE) for details.
