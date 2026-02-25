
{
  "role": "Principal iOS Architect",
  "architecture_style": "Clean Architecture (Presentation / Domain / Data)",
  "environment_support": ["Sandbox", "Production"],
  "platform_target": "iOS",
  "xcode_version": "26.2",
  "analysis_required": true,
  "instructions": {
    "pre_implementation": [
      "Scan the entire project.",
      "Identify networking layer (APIClient, NetworkManager, RequestBuilder, Interceptor, etc.).",
      "Identify how MELI_ACCESS_TOKEN is injected into headers.",
      "Identify dependency injection strategy.",
      "Do not duplicate architecture patterns."
    ]
  },
  "objective": "Implement a fully secure, enterprise-level MercadoLibre OAuth refresh token flow with automatic retry and centralized token management.",
  "service_specification": {
    "endpoint": "https://api.mercadolibre.com/oauth/token",
    "method": "POST",
    "content_type": "application/x-www-form-urlencoded",
    "parameters": {
      "grant_type": "refresh_token",
      "client_id": "dynamic",
      "client_secret": "dynamic",
      "refresh_token": "dynamic"
    }
  },
  "architecture_requirements": {
    "presentation_layer": [
      "No networking logic here."
    ],
    "domain_layer": [
      "Create RefreshTokenUseCase protocol.",
      "Use dependency inversion.",
      "No URLSession references."
    ],
    "data_layer": [
      "Implement AuthRepository.",
      "Implement AuthService.",
      "Reuse existing networking client.",
      "Add RequestInterceptor if missing."
    ]
  },
  "models": {
    "request": {
      "name": "RefreshTokenRequestDTO",
      "requirements": [
        "Encodable",
        "Form-url-encoded body builder",
        "No hardcoded values"
      ]
    },
    "response": {
      "name": "RefreshTokenResponseDTO",
      "type": "Decodable",
      "fields": [
        "access_token",
        "token_type",
        "expires_in",
        "scope",
        "user_id",
        "refresh_token"
      ]
    }
  },
  "token_management": {
    "storage": "Keychain ONLY",
    "create_actor": "TokenStoreActor",
    "requirements": [
      "Thread-safe",
      "Single source of truth",
      "getAccessToken() async",
      "setAccessToken() async",
      "clearToken() async"
    ]
  },
  "automatic_refresh_flow": {
    "requirements": [
      "Implement RequestInterceptor.",
      "On 401 → trigger refresh.",
      "Retry original request once after successful refresh.",
      "Prevent multiple simultaneous refresh calls using actor synchronization.",
      "Queue pending requests while refresh is in progress."
    ]
  },
  "environment_configuration": {
    "requirements": [
      "Create Environment enum (sandbox, production).",
      "Base URL must depend on environment.",
      "Client ID and Secret must be injected via configuration layer.",
      "Never read secrets directly from Info.plist after launch."
    ]
  },
  "security_constraints": [
    "Do not log client_secret.",
    "Do not store tokens in UserDefaults.",
    "Do not modify Info.plist at runtime.",
    "Do not expose sensitive data in debug logs."
  ],
  "error_handling": {
    "create_enum": "AuthError",
    "handle_status_codes": [400, 401, 403, 500],
    "handle_cases": [
      "invalid_grant",
      "expired_refresh_token",
      "network_failure",
      "decoding_error"
    ]
  },
  "concurrency": {
    "use": "Swift Concurrency",
    "mechanism": [
      "actor for refresh lock",
      "async/await",
      "Task suspension for pending requests"
    ]
  },
  "testing_requirements": [
    "Ensure service compiles.",
    "Ensure no retain cycles.",
    "Ensure no memory leaks.",
    "Ensure no duplicated logic."
  ],
  "build_validation": {
    "required": true,
    "steps": [
      "Build project in Xcode 26.2.",
      "Resolve all compilation errors.",
      "Resolve all warnings.",
      "Resolve Swift concurrency warnings.",
      "Resolve deprecation warnings.",
      "Ensure SwiftLint passes if configured.",
      "Verify no architectural violations introduced."
    ]
  },
  "expected_behavior": [
    "If token is valid → normal flow.",
    "If token expired → automatic refresh.",
    "If refresh succeeds → retry original request.",
    "If refresh fails → propagate AuthError.",
    "All existing services continue working without modification."
  ],
  "final_instruction": "Do not finish until project builds clean in Xcode 26.2 with zero warnings."
}
