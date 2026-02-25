//
//  Untitled.swift
//  MeliApp
//
//  Created by william niño on 24/02/26.
//

ROLE
You are a Senior iOS Software Architect and Technical Documentation Specialist.

OBJECTIVE
Generate a professional “Architecture Documentation with Diagrams” section for a Clean Architecture iOS project developed for the Mercado Libre Mobile Challenge.

IMPORTANT
The documentation must strictly reflect what is actually implemented in the project. Do not invent features, patterns, or layers that are not present.

PROJECT CONTEXT (REAL IMPLEMENTATION)

The project includes:

- SwiftUI
- MVVM
- Clean Architecture separation
- ViewState enum for UI state management
- @MainActor ViewModels
- UseCase layer
- Repository pattern (protocol + implementation)
- URLSession-based HTTPClient
- Endpoint abstraction
- Typed AppError enum
- HTTP status code categorization (401, 403, 404, 5xx)
- Async/await concurrency
- Debounced search input
- Cancelable Task handling
- Unit tests for SearchViewModel and DetailViewModel
- Logging layer (AppLogger)
- No pagination
- No caching layer
- No dependency injection framework (manual injection)

REQUIREMENTS

The output must include:

1) A layered architecture diagram (Mermaid flowchart)
   Showing:
   - SwiftUI View
   - ViewModel (@MainActor)
   - UseCase
   - Repository Protocol
   - Repository Implementation
   - HTTPClient
   - External MercadoLibre API

2) A sequence diagram (Mermaid sequenceDiagram)
   Describing:
   - Search flow
   - User input → View → ViewModel → UseCase → Repository → HTTPClient → API
   - Response propagation back to View

3) A short written explanation of:
   - Why Clean Architecture was chosen
   - Responsibility separation
   - Why ViewModel is @MainActor
   - Why networking is isolated from UI
   - How testability is achieved

4) A short section explaining:
   - How errors flow across layers
   - Where HTTP status codes are mapped
   - How AppError bridges developer-side and user-side handling

STYLE CONSTRAINTS

- Professional tone
- Technical clarity
- No marketing language
- No emojis
- No exaggerated claims
- No features not implemented
- Concise but complete
- Suitable for senior-level code review

OUTPUT FORMAT

- Markdown
- Mermaid diagrams compatible with GitHub
- Proper heading hierarchy
- Clean indentation
- Ready to paste into README.md

DO NOT:

- Add pagination
- Add caching
- Add dependency injection frameworks
- Add CI/CD
- Add architecture not present in the codebase
- Add performance claims not measurable

The documentation must accurately reflect the real project structure.
