# TrackIt - Daily Habits Tracker

## 📱 Overview

TrackIt is a utility application that helps users build and maintain daily habits. The app features a clean, intuitive interface for managing habits, with intelligent flow management that adapts to user context and preferences.

## ✨ Features

### Core Functionality
- **Habit Management**: Create, edit, delete, and track completion of daily habits
- **Onboarding Flow**: Smooth 4-screen onboarding experience for new users
- **Paywall Integration**: Context-aware premium subscription flow
- **Data Persistence**: CoreData integration for reliable data storage

### Intelligent Flow Management
The app includes a sophisticated decision engine that determines user flows based on:
- User locale and region
- Timezone information
- Language preferences
- First launch status

## 🏗️ Architecture

The project follows **SOLID principles** and clean architecture patterns:

### Architecture Layers

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (ViewControllers, Views, ViewModels)│
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│          Domain Layer                │
│    (Business Logic, Use Cases)       │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│          Data Layer                  │
│  (CoreData, UserDefaults, Services)  │
└─────────────────────────────────────┘
```

### Key Design Principles

- **Separation of Concerns**: Clear boundaries between UI, business logic, and data layers
- **Protocol-Oriented Programming**: Extensive use of protocols for flexibility
- **Dependency Injection**: Services and managers are injected where needed
- **Reactive Programming**: Combine framework for reactive data flow
- **Composition over Inheritance**: Prefer composition for code reuse

## 📂 Project Structure

```
TrackIt/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── Coordinators/
│       └── Protocols/
│           └── MainCoordinatorProtocol.swift
│
├── Modules/
│   ├── Home/
│   │   ├── HomeVC.swift
│   │   ├── HomeViewModel.swift
│   │   ├── Models/
│   │   │   └── Habit.swift
│   │   └── Views/
│   │       ├── HomeView.swift
│   │       └── Subviews/
│   │           └── HabitsTable/
│   │
│   ├── Onboarding/
│   │   ├── OnboardingVC.swift
│   │   ├── Factories/
│   │   │   └── OnboardingFactory.swift
│   │   ├── Models/
│   │   │   └── PageModel.swift
│   │   ├── Page/
│   │   │   ├── PageVC.swift
│   │   │   └── Views/
│   │   │       └── PageView.swift
│   │   └── Views/
│   │       └── OnboardingView.swift
│   │
│   └── Paywall/
│       ├── PaywallVC.swift
│       ├── PaywallViewModel.swift
│       └── Views/
│
├── Services/
│   ├── Decision/
│   │   ├── DecisionEngine.swift
│   │   └── Models/
│   │       ├── FlowType.swift
│   │       ├── DecisionResult.swift
│   │       ├── UserContext.swift
│   │       └── AlternativeContent.swift
│   │
│   └── Purchase/
│       ├── PurchaseService.swift
│       └── PurchaseError.swift
│
├── Managers/
│   ├── CoreData/
│   │   ├── CoreDataManager.swift
│   │   ├── HabitEntity+CoreDataClass.swift
│   │   └── HabitEntity+CoreDataProperties.swift
│   │
│   └── Premium/
│       └── PremiumManager.swift
│
└── Sources/
    ├── Constants/
    │   └── Colors.swift
    ├── Extensions/
    │   ├── UIView.swift
    │   ├── UIViewController.swift
    │   └── UIImage.swift
    ├── TypeAliases/
    │   └── VoidBlock.swift
    ├── UI/
    │   └── Views/
    │       ├── PrimaryButton.swift
    │       └── CustomNavigationBar/
    │           ├── CustomNavigationBar.swift
    │           ├── EditMenu.swift
    │           └── PremiumBadge.swift
    └── UserDefaults/
        ├── UserDefaultsStorage.swift
        └── UserDefaultsStoring.swift
```

## 🧠 Decision Engine

The Decision Engine is a core component that intelligently determines application flows based on user context. It's fully encapsulated and operates transparently within the application.

### How It Works

The Decision Engine analyzes user context and calculates a score based on:

1. **Region Analysis**: Extracts region code from user's locale
2. **Timezone Evaluation**: Determines timezone offset and categorizes it
3. **Language Detection**: Identifies user's preferred language

### Scoring System

The engine calculates a score (0-100) using the following factors:

| Factor | High Value | Standard Value |
|--------|-----------|----------------|
| **Region** | US, CA, GB, AU, DE, FR, IT, ES, NL, SE, NO, DK (+40) | Other regions (+20) |
| **Timezone** | North America UTC-8 to UTC-5 (+30)<br>Europe UTC-2 to UTC+3 (+25) | Other timezones (+15) |
| **Language** | English (+20) | Other languages (+10) |

### Flow Determination

Based on the calculated score:

- **Score ≥ 70**: Show full Paywall experience
- **Score ≥ 40**: Show alternative content (customized headline and CTA)
- **Score < 40**: Skip Paywall

### Implementation Details

```swift
// The Decision Engine is accessed through a singleton pattern
let context = UserContext.current()
let decisionResult = DecisionEngine.shared.determineFlow(for: context)

switch decisionResult.flowType {
case .showPaywall:
    // Show standard paywall
case .alternativeContent(let content):
    // Show paywall with alternative content
case .skipPaywall:
    // Skip paywall entirely
}
```

### Key Features

- **Encapsulated Logic**: All decision logic is contained within the `DecisionEngine` class
- **Context-Aware**: Uses real user data (locale, timezone, language)
- **Extensible**: Easy to add new factors or modify scoring logic
- **Testable**: Pure functions make unit testing straightforward

## 🎨 UI Components

### Custom Components

- **PrimaryButton**: Reusable primary action button with tap handling
- **CustomNavigationBar**: Custom navigation bar with title and action menu
- **EditMenu**: Context menu for bulk actions (complete all, delete completed)
- **PremiumBadge**: Dynamic badge showing premium status
- **HabitsTableView**: Custom table view for displaying habits grouped by date

### Design System

- **Colors**: Centralized color management with primary colors and gradients
- **Typography**: Consistent font usage throughout the app
- **Spacing**: SnapKit for consistent layout constraints

## 💾 Data Management

### CoreData

- **HabitEntity**: Core Data model for habit persistence
- **CoreDataManager**: Singleton manager for all CoreData operations
- Automatic data grouping by creation date

### UserDefaults

- **UserDefaultsStorage**: Type-safe wrapper for UserDefaults
- Stores: onboarding status, premium status, app first launch flag

## 🔄 State Management

The app uses **Combine** framework for reactive state management:

- ViewModels publish state changes via `@Published` properties
- ViewControllers subscribe to state changes
- Automatic UI updates when data changes

## 🛠️ Technologies

- **Swift 5+**: Modern Swift with latest language features
- **UIKit**: Native iOS UI framework
- **SnapKit**: Declarative Auto Layout DSL
- **Combine**: Reactive programming framework
- **CoreData**: Data persistence
- **StoreKit**: In-app purchase integration

## 🚀 Getting Started

### Installation

1. Clone the repository:
```bash
git clone git@github.com:andreichenko256/TrackIt.git
cd TrackIt
```

2. Open the project in Xcode:
```bash
open TrackIt.xcodeproj
```

3. Build and run the project (⌘R)

### Configuration

The app uses StoreKit Configuration file for testing purchases:
- File: `testingPurchases.storekit`
- Product ID: `premium_month`

## 🧪 Testing Decision Engine

To test different flows:

1. **Reset onboarding**: Delete the app or clear UserDefaults
2. **Change device settings**: Modify locale, timezone, or language in iOS Settings
3. **Check console logs**: Decision Engine logs all calculations for debugging

### Example Test Scenarios

- **High Score (Paywall)**: US locale + EST timezone + English → Score: 90
- **Medium Score (Alternative)**: UA locale + EET timezone + English → Score: 65
- **Low Score (Skip)**: Any region + any timezone + any language → Score: 45+

## 📝 Code Style

The project follows strict coding guidelines:

- **SOLID Principles**: All code adheres to SOLID principles
- **Protocol-Oriented**: Prefer protocols over concrete types
- **Explicit Code**: Readable code over clever abstractions
- **No God Objects**: Clear separation of responsibilities
- **Composition**: Prefer composition over inheritance
