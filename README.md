# MeliApp — Mercado Libre Mobile Challenge (iOS)

## Objective
This project was developed as part of the Mercado Libre Mobile Challenge. It integrates with the MercadoLibre API to display a dynamic list of products. Users can explore the catalog by searching for items and accessing detailed information about each product.

## Starting 🚀
You might clone the project through the next repository -> https://github.com/willin21/MeliApp.git

The goal is to build a native iOS application that:
- Allows users to search products using Mercado Libre APIs.
- Displays a list of results.
- Shows a detailed view of a selected product.
- Maintains state during screen rotation.
- Handles developer-side and user-side errors properly.
- Ensures code quality and testability.

## Architecture
This project follows Clean Architecture principles combined with MVVM.

### Architecture Overview
1) SwiftUI View
2) ViewModel (@MainActor)
3) UseCase (Application Layer)
4) Repository (Data Abstraction)
5) HTTPClient (Infrastructure Layer)

### Layers
Presentation
- SwiftUI Views
- ViewModels (state management)
- ViewState enum for UI state

Domain
- UseCases
- Business models
- Repository protocols

Data
- Repository implementations
- DTOs
- Mapping logic

Core
- Networking (URLSessionHTTPClient)
- Error handling (AppError)
- Logging (AppLogger)
- Utilities (formatters, extensions)

## Design Patterns Used
- MVVM
- Repository Pattern
- Dependency Injection
- Protocol-Oriented Programming
- Clean Architecture separation of concerns

## Apple Human Interface Guidelines Applied
The implementation follows Apple’s official Human Interface Guidelines for iOS:

Native Navigation
- NavigationStack used for hierarchical navigation.
- Clear back navigation behavior.
- Proper screen transitions.

System Components
- Native SwiftUI components (List, ProgressView, Text, Button).
- Avoided custom UI components where system components provide better UX consistency.

Loading & Feedback
- ProgressView for loading states.
- Explicit empty state messaging.
- Clear error messaging with retry option.

State Preservation
- @StateObject ensures state persistence across screen rotations.
- ViewModels isolated with @MainActor for UI safety.

Responsiveness
- Debounced search input to prevent excessive API calls.
- Cancelable asynchronous tasks.
- Non-blocking UI updates using async/await.

Content Clarity
- Clear typography hierarchy.
- Concise error messaging.
- Avoidance of technical jargon in UI.

Platform Conventions
- Safe area respect.
- Standard spacing.

## State Management
Each screen uses a ViewState enum:
.idle
.loading
.loaded(data)
.empty(message)
.error(AppError)

This guarantees:
- Clear UI transitions
- Explicit handling of all states
- Testable state changes
- Safe rotation handling

## Error Handling Strategy
Error handling is implemented at two levels:

Developer-Side
- Typed AppError
- HTTP status code mapping
- Decoding error detection
- Structured logging via AppLogger

User-Side
AppError exposes a userMessage property, which maps technical errors to user-friendly messages.

This ensures:
- No technical errors leak to UI
- Consistent messaging
- Better user experience

## Networking
Networking is implemented using:
- URLSession
- Generic HTTPClient
- Endpoint abstraction
- Typed error handling
- Status code categorization (401, 403, 404, 5xx)

The networking layer is isolated from UI and domain logic.

## Testing Strategy
Unit tests were implemented for:
- SearchViewModel
- DetailViewModel

Using:
- Mock repositories
- Controlled success & failure scenarios
- Async testing with @MainActor

Focus areas:
- State transitions
- Error propagation
- Loaded data validation

## User Experience Considerations
- Debounced search input
- Cancelable search tasks
- Loading state indicators
- Empty state messaging
- Error state with retry
- State persistence during rotation

## Possible Improvements (Future Work)
- Pagination support (offset/limit)
- Local caching strategy (URLCache or persistence layer)
- Snapshot testing
- Integration tests
- Accessibility enhancements
- Dark mode optimization (if expanded)

## Technical Requirements
- iOS 16+
- Swift 5.9 / Swift 6 compatible
- Xcode 15+

## Why Clean Architecture?
Clean Architecture was chosen to:
- Improve scalability
- Maximize testability
- Decouple networking from UI
- Facilitate future feature expansion

## Final Notes
This implementation focuses on:
- Maintainable structure
- Clear responsibility separation
- Robust error handling
- Testability
- Swift concurrency safety

## Author ✒️
Developed by William Antonio Niño Ramírez.
