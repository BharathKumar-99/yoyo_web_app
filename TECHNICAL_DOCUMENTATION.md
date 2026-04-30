# Yoyo Web App Technical Documentation

## 1. Project Overview

**Yoyo Web App** is a Flutter-based web application tailored for managing schools, teachers, students, and their associated data (such as phrases, homework, and notifications). The app connects to a **Supabase** backend for authentication, database operations, and real-time features.

### Core Technologies
- **Framework:** Flutter (Web Support enabled)
- **Backend/BaaS:** Supabase (`supabase_flutter` for Auth, DB, and Realtime changes)
- **State Management:** Provider (`provider` package)
- **Routing:** GoRouter (`go_router` package)
- **UI Architecture:** Feature-based folder structure, using a `ChangeNotifier` and `Repository` pattern.

---

## 2. Architecture & Folder Structure

The application adopts a feature-first architecture, separating logical domains into dedicated folders inside `lib/features`. Core utilities and app-wide configurations are kept separate.

### `lib/` directory overview
- **`config/`**: Contains app-level configurations.
  - `router/`: GoRouter setup (`app_router.dart`, `route_names.dart`).
  - `theme/`: App-wide theming configs (`app_theme.dart`).
  - `constants/`: Global constants (like API URLs).
- **`core/`**: Shared services and UI.
  - `api/`: Low-level network or repo wrappers.
  - `supabase/`: Centralized Supabase initialization (`supabase_client.dart`).
  - `widgets/`: Reusable UI components (e.g., `responsive_screen.dart`).
- **`features/`**: The core business modules of the app. Every feature generally includes its own `presentation/` (UI & view models) and `model/` or `data/` layers.
- **`main.dart`**: The entry point. Initializes Supabase, configures the `MultiProvider` for state injection, and sets up `GoRouter`.

---

## 3. Core Modules & Features

### 3.1 Authentication & Role Management
- **Login (`features/login/`):** Handles user sign-in via Supabase Auth.
- **Activation (`features/activate_user/`):** Code-based account activation.
- **Role Detection (`CommonViewModel`):** Users are categorized into Admins, Teacher Admins, and Teachers. The `CommonViewModel` determines role-based UI access based on the `UserModel` and `Teacher` records fetched from Supabase.

### 3.2 School Management
- Managed via: `features/add_school/`, `features/edit_school/`, `features/view_school/`, `features/my_school/`.
- Admins can create and edit schools. Teachers are assigned to specific schools.
- `CommonViewModel` globally tracks the currently `selectedSchool` and `selectedClass` to scope data views across the app.

### 3.3 User & Teacher Management
- Handled in: `features/users/`, `features/add_user/`, `features/edit_user/`, `features/add_teacher/`.
- Enables listing, adding, and updating student and teacher records in the system.

### 3.4 Homework & Phrases
- **Homework (`features/homework/`):** View, assign, and track student homework. Tied closely to `SetHomeworkViewmodel` and `DashboardViewModel`.
- **Phrases (`features/phrases/`, `features/add_phrases/`):** Manage linguistic phrases or educational content blocks used by students.

### 3.5 Notifications
- Handled in `features/notification/` and `features/send_notification/`.
- Employs **Supabase Realtime Channels**. In `CommonViewModel`, `listenTeacherNotification()` listens for real-time Postgres changes on the `teacher` table to instantly alert teachers of new events.

### 3.6 Profile & Settings
- `features/profile/` and `features/settings/` for generic user preferences, profile details viewing, and app settings.

---

## 4. State Management

The app uses the `provider` package to manage app state effectively.
- **Global State:** `CommonViewModel` acts as the root state holder. It manages session info, roles, active schools, active classes, and real-time notification flags.
- **Proxy Providers:** `ChangeNotifierProxyProvider` is heavily utilized in `main.dart` to inject `CommonViewModel` into other feature-specific ViewModels (e.g., `HomeViewModel`, `PhrasesViewModel`, `UsersViewModel`). This ensures that feature logic always has access to the current school, class, and user identity.
- **Repository Pattern:** ViewModels do not perform database queries directly. They rely on corresponding `*Repo` classes (e.g., `CommonRepo`) to execute Supabase transactions.

---

## 5. Routing

Routing is managed by `go_router` configured in `lib/config/router/app_router.dart`.
- **ShellRoute:** A `ShellRoute` is used to wrap most app pages within a `DashboardScreen`, providing a consistent sidebar/navbar layout.
- **Redirection Logic:** `GoRouter` includes a global redirect handler. It intercepts route changes, checks the `Supabase.instance.client.auth.currentUser`, and forces a redirect to the login screen if the user is unauthenticated (except for public routes like `activate`).

---

## 6. Dependency Highlights (`pubspec.yaml`)
- `supabase_flutter`: Backend-as-a-service for DB and Auth.
- `provider`: State Management.
- `go_router`: Navigation.
- `excel` / `csv`: Data import/export features.
- `file_picker` / `file_saver`: File handling.
- `pdf` / `printing`: Report generation.
- `just_audio`: Audio playback (likely for phrases).

---

## 7. Setup & Run Instructions

1. Ensure Flutter SDK (`^3.9.2`) is installed.
2. Clone the repository and navigate into it.
3. Run `flutter pub get` to install dependencies.
4. (Optional) Adjust Dev/Prod keys in `UrlConstants` if connecting to a specific Supabase instance. The app uses `SupabaseClientService.instance.init(dev: false)` in `main.dart` by default.
5. Run the web app:
   ```bash
   flutter run -d chrome
   ```
