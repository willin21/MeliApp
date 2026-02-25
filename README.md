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

## Architecture Diagrams
1️⃣ Layered Architecture Diagram
flowchart TD
    
    A [SwiftUI View] --> B[ViewModel @MainActor]
    
    B --> C[UseCase]
    
    C --> D[Repository Protocol]
    
    D --> E[Repository Implementation]
    
    E --> F[HTTPClient]
    
    F --> G[MercadoLibre API]
    
Explanation
- The View observes state changes.
- The ViewModel manages UI state and user interaction.
- The UseCase contains application-specific logic.
- The Repository abstracts data sources.
- The HTTPClient handles networking and error mapping.
- The external API is isolated from upper layers.

This ensures:
- Clear separation of concerns
- Testability
- Scalability
- Independent layer evolution

2️⃣ Data Flow Diagram (Search Flow)

sequenceDiagram

    participant User
    participant View
    participant ViewModel
    participant UseCase
    participant Repository
    participant HTTPClient
    participant API

    User->>View: Types search query
    View->>ViewModel: onQueryChanged()
    ViewModel->>UseCase: execute(query)
    UseCase->>Repository: searchItems()
    Repository->>HTTPClient: send()
    HTTPClient->>API: HTTP Request
    API-->>HTTPClient: JSON Response
    HTTPClient-->>Repository: Decoded DTO
    Repository-->>UseCase: Domain Model
    UseCase-->>ViewModel: SearchPage
    ViewModel-->>View: Updated State

### Architectural Rationale
Clean Architecture was selected to:
- Separate business logic from UI and infrastructure
- Improve testability of ViewModels and UseCases
- Isolate networking concerns
- Facilitate future scalability (pagination, caching, new data sources)

This design allows:
- Independent testing of ViewModels
- Clear responsibility boundaries
- Safer concurrency management with @MainActor at presentation layer only

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

## API Endpoints Used
The application integrates directly with the official MercadoLibre public APIs.

### 1️⃣ Search Items
Used to retrieve a paginated list of products based on a search query.

**Endpoint**
GET https://api.mercadolibre.com/sites/{SITE_ID}/search?q={query}

**Purpose**
- Fetch product list
- Retrieve basic product information
- Populate search results screen
---

### 2️⃣ Item Detail
Used to retrieve detailed information about a specific product.

**Endpoint**
GET https://api.mercadolibre.com/items/{ITEM_ID}

**Purpose**
- Retrieve detailed product attributes
- Show price, availability, condition
- Display extended product information

### Integration Notes
- All requests are executed through a generic `HTTPClient`.
- Responses are decoded into DTOs and mapped into domain models.
- HTTP status codes are categorized and converted into typed `AppError`.
- Networking logic is fully isolated from presentation and domain layers.

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

## AI Usage
Artificial Intelligence tools were used as development assistants during this project.

### Models
GPT-4 / GPT-5 family models

### Scope of AI Assistance
AI was used to assist with:

- Refinement of architectural documentation
- Generation of architecture diagrams in Mermaid format
- Review and improvement of error handling structure
- Unit test validation adjustments
- README drafting and formatting

AI assistance focused on documentation clarity, structural validation, and best practice suggestions.

### Human Oversight

All AI-generated suggestions were:

- Manually reviewed
- Adjusted when necessary
- Aligned with the actual project implementation
- Verified through compilation and unit testing

AI was used as a productivity and documentation assistant, not as an autonomous code generator.

### Prompt Documentation
The prompts used to generate technical documentation are included in the repository:

- `docs/ai/README_prompt.md`
- `docs/ai/architecture_documentation_prompt.md`
- `docs/ai/oauth_refresh_token_prompt.md`

These prompts reflect how AI was guided to produce structured documentation aligned with the real project implementation.

## Final Notes
This implementation focuses on:
- Maintainable structure
- Clear responsibility separation
- Robust error handling
- Testability
- Swift concurrency safety

## Author ✒️
Developed by William Antonio Niño Ramírez.
