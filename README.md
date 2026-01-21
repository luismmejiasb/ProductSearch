# ProductSearch

**ProductSearch** is an iOS application built in **Swift** that consumes **Mercado Libre’s REST API** to search and display product information.  
The main goal of this project is to demonstrate a **clean, scalable VIPER architecture**, with clear separation of concerns, testable components, and production-ready structure.

The project uses **CocoaPods** for dependency management, **Property Lists** for environment configuration, and supports **Localization / Internationalization** out of the box.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-iOS%2014.5+-blue.svg)
![Swift](https://img.shields.io/badge/swift-5.x-orange.svg)

---

## 1. Getting Started

### Prerequisites

- Swift 5.x  
- Xcode 16 or later  
- iOS 18+

### Setup

This project uses **Swift Package Manager (SPM)** for dependency management.

```bash
git clone https://github.com/your-repo/ProductSearch.git
cd ProductSearch
open ProductSearch.xcodeproj
```

---

## 2. Architecture Overview

This project follows a **strict VIPER architecture**, focused on maintainability, testability, and long-term scalability.

### VIPER Module Structure

Each feature is implemented as an independent module composed of:

- **View**
  - `UIViewController`
  - UI rendering only
  - No business logic

- **Presenter**
  - Orchestrates the module
  - Receives user actions from the View
  - Requests data from the Interactor
  - Formats data for presentation
  - Coordinates navigation through the Router

- **Interactor**
  - Contains business rules and use cases
  - Communicates only with the Repository
  - No UI logic

- **Entity**
  - Plain Swift models
  - Decoupled from UI and persistence

- **Router (Wireframe)**
  - Handles navigation and presentation logic
  - Responsible for alerts, transitions, and module routing

- **Factory**
  - Assembles the module
  - Injects all dependencies explicitly

- **Repository**
  - Single source of truth for data
  - Coordinates:
    - **CloudDataSource** (REST API)
    - **LocalDataSource** (in-memory / persistence)

---

## 3. Dependency Flow

The dependency graph is **unidirectional** and enforced by protocols:

```
View → Presenter → Interactor → Repository → DataSources
                     ↓
                   Router
```

Key rules:

- Inner layers **never know** about outer layers
- Communication is **protocol-driven**
- No shared mutable state
- No UIKit outside the View & Router
- `@MainActor` is applied where UI interaction is required

> Think of VIPER as an onion: dependencies always point inward.

---

## 4. Configuration & Environment

- **Property List (.plist)** is used for:
  - API base URLs
  - Environment-specific keys
- This avoids hard-coded values and keeps configuration externalized.

---

## 5. Localization

The application supports **Localization / Internationalization** using:

- `Localizable.strings`
- Language-agnostic UI rendering
- No hardcoded user-facing strings in code

---

## 6. Design Patterns Used

### a) VIPER

Primary architectural pattern, strictly enforced.

### b) Delegation

Used where appropriate and aligned with UIKit conventions:

- `UITableViewDelegate`
- `UISearchBarDelegate`
- Custom routing or communication delegates

Delegation is used **only** when it makes sense, not as a default communication mechanism.

### c) Singleton (Limited Usage)

Singletons are used sparingly and intentionally, for example:

- Global UI helpers such as loading indicators

> No business logic or stateful flows rely on Singletons.

---

## 7. Unit Testing

Due to time constraints, this version does **not include full unit test coverage**.

However, the architecture is fully testable:
- Presenter, Interactor, and Repository layers are protocol-driven
- No hard dependencies on UIKit in business logic

You can see a **fully tested VIPER example** here:  
👉 https://github.com/luismmejiasb/ArtistSearch

---

## 8. Versioning

This project follows **Semantic Versioning**:

https://semver.org

```
MAJOR.MINOR.PATCH
```

---

## 9. Key Takeaways

- Clean VIPER implementation
- Explicit dependency injection
- No hidden coupling
- Scalable module structure
- Production-ready architecture
