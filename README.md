# family_inventory_app

A Flutter application for managing a shared family inventory across multiple dashboards.  
Designed to be usable on both **mobile** and **desktop**, with full management features even when a PC isn’t available.

---

## Overview

This app allows a family to keep track of items such as clothing, groceries, or other household goods.  
Items are organized into **dashboards**, **categories**, and **subcategories**, with dedicated management pages for editing everything globally or individually.

---

## Current Features

### Dashboards
- Create multiple dashboards (e.g. Clothing, Groceries).
- Navigate between dashboards.
- Manage dashboards individually or through a global management page.
- Rename and delete dashboards.

### Items
- Add items with:
  - Name
  - Category & subcategory
  - Image
- Edit item details directly from the item card.
- Delete items.
- Filter items by category or subcategory.

### Categories & Subcategories
- Create, rename, and delete categories.
- Create, rename, and delete subcategories.
- Changes automatically propagate to all affected items without needing a manual refresh.

### Management Pages
- **Dashboard Management Page**
  - Manage categories and subcategories for a single dashboard.
- **Global Dashboards Management Page**
  - Manage all dashboards at once (rename, delete, sort).

### UX / Behavior
- State updates correctly when navigating between pages.
- No manual reload required for updates to reflect.
- Full-screen management pages for better mobile usability.

---

## Tech Stack

- **Flutter**
- **Dart**
- Material UI
- In-memory state management (no persistence yet)

---

## Project Structure (Simplified)

lib/
├── models/
│ ├── dashboard.dart
│ └── inventory_item.dart
├── screens/
│ ├── dashboards_page.dart
│ ├── dashboard_page.dart
│ ├── dashboard_management_page.dart
│ └── dashboards_management_page.dart
├── widgets/
│ └── inventory_card.dart

---

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio, VS Code, or Xcode (for iOS builds)

---

### Run the App

```bash
flutter pub get
flutter run
```
---

## Notes / Future Plans

- Persistent storage (SQLite / Firebase).
- Shared sync across devices.
- Expanded inventory types (beyond clothing and laundry).
- Improved sorting and bulk-edit tools.

---

## License

MIT License

---