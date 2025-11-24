# 🔐 API Key Security Architecture

## Before (Insecure) ❌

```
┌─────────────────────────────────────────┐
│         NetworkManager.swift            │
│                                         │
│  class NetworkManager {                 │
│    private let apiKey =                 │
│      "YOUR_TMDB_API_KEY" // Hardcoded! │
│  }                                      │
│                                         │
│  ⚠️  Committed to Git                   │
│  ⚠️  Visible in repository              │
│  ⚠️  Exposed in history                 │
└─────────────────────────────────────────┘
```

## After (Secure) ✅

```
┌─────────────────────────────────────────────────────────────┐
│                    Security Architecture                     │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────┐        ┌──────────────────────┐
│  Configuration.plist │        │ Configuration.plist  │
│      .example        │        │    (actual file)     │
│                      │        │                      │
│  ✅ In Git           │        │  ❌ NOT in Git       │
│  ✅ Template only    │        │  ✅ Has real API key │
│  ✅ Placeholder      │  ────► │  ✅ Local only       │
│                      │  copy  │  ✅ In .gitignore    │
└──────────────────────┘        └──────────────────────┘
                                          │
                                          │ reads at runtime
                                          ▼
                              ┌──────────────────────┐
                              │  NetworkManager.swift│
                              │                      │
                              │  private init() {    │
                              │    // Load from plist│
                              │    self.apiKey =     │
                              │      loadFromConfig()│
                              │  }                   │
                              │                      │
                              │  ✅ No hardcoded key │
                              │  ✅ Runtime loading  │
                              │  ✅ Validation       │
                              └──────────────────────┘
```

## File Structure

```
ios_viper_example/
│
├── .gitignore
│   └── Contains: Configuration.plist  ← Prevents commits
│
├── Configuration.plist.example  ← Template (in Git)
│   └── <key>TMDB_API_KEY</key>
│       <string>YOUR_TMDB_API_KEY</string>
│
├── Configuration.plist  ← Real file (NOT in Git)
│   └── <key>TMDB_API_KEY</key>
│       <string>abc123real456key789</string>
│
├── setup.sh  ← Automated setup
│   └── Copies .example → .plist
│       Prompts for API key
│       Configures automatically
│
└── Common/Network/NetworkManager.swift
    └── Loads API key from Configuration.plist
        Validates configuration
        Fails fast with clear error
```

## Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     Application Launch                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │ NetworkManager   │
                    │   .shared        │
                    └──────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  init() called   │
                    └──────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────┐
        │ Load Configuration.plist from Bundle    │
        └─────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
            ┌──────────────┐    ┌──────────────┐
            │ File found?  │    │ File missing │
            │     YES      │    │      NO      │
            └──────────────┘    └──────────────┘
                    │                   │
                    ▼                   ▼
        ┌────────────────────┐  ┌──────────────┐
        │ Parse TMDB_API_KEY │  │  fatalError  │
        └────────────────────┘  │  with clear  │
                    │            │   message    │
                    │            └──────────────┘
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
┌──────────────┐        ┌──────────────┐
│ Valid key?   │        │ Placeholder? │
│   YES        │        │     NO       │
└──────────────┘        └──────────────┘
        │                       │
        ▼                       ▼
┌──────────────┐        ┌──────────────┐
│ Use API key  │        │  fatalError  │
│ ✅ Success   │        │  with clear  │
└──────────────┘        │   message    │
                        └──────────────┘
```

## Security Layers

```
┌─────────────────────────────────────────────────────────────┐
│                      Security Layers                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Layer 1: .gitignore                                        │
│  ├─ Prevents Configuration.plist from being committed       │
│  └─ First line of defense                                   │
│                                                              │
│  Layer 2: Template File (.example)                          │
│  ├─ Only placeholder in repository                          │
│  └─ No real credentials                                     │
│                                                              │
│  Layer 3: Runtime Validation                                │
│  ├─ Checks if file exists                                   │
│  ├─ Validates key is not placeholder                        │
│  └─ Fails fast with helpful error                           │
│                                                              │
│  Layer 4: Documentation                                     │
│  ├─ SECURITY.md - Best practices                            │
│  ├─ QUICKSTART.md - Quick setup                             │
│  └─ Clear error messages                                    │
│                                                              │
│  Layer 5: Automated Setup                                   │
│  ├─ setup.sh script                                         │
│  └─ Reduces human error                                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Developer Workflow

```
┌──────────────────────────────────────────────────────────────┐
│              New Developer Onboarding                         │
└──────────────────────────────────────────────────────────────┘

1. Clone Repository
   │
   ├─ Contains: Configuration.plist.example ✅
   └─ Does NOT contain: Configuration.plist ✅
   
2. Run Setup
   │
   ├─ Option A: ./setup.sh (automated)
   └─ Option B: Manual copy + edit
   
3. Get API Key
   │
   └─ Visit TMDB website
       Create account
       Generate API key
   
4. Configure
   │
   └─ Edit Configuration.plist
       Replace placeholder with real key
   
5. Build & Run
   │
   ├─ NetworkManager loads key at runtime
   └─ App works! ✅

6. Develop
   │
   ├─ Configuration.plist stays local
   ├─ Never committed to Git
   └─ Each developer has their own key
```

## Comparison Table

| Aspect                | Before (Hardcoded) | After (Config File) |
|-----------------------|-------------------|---------------------|
| **Security**          | ❌ Exposed        | ✅ Protected        |
| **Git History**       | ❌ Visible        | ✅ Hidden           |
| **Key Rotation**      | ❌ Difficult      | ✅ Easy             |
| **Team Collaboration**| ❌ Shared key     | ✅ Individual keys  |
| **Public Repos**      | ❌ Dangerous      | ✅ Safe             |
| **Setup Complexity**  | ✅ Simple         | ⚠️  One-time setup  |
| **Runtime Safety**    | ❌ No validation  | ✅ Validated        |
| **Documentation**     | ❌ Minimal        | ✅ Comprehensive    |

## Benefits Summary

✅ **Security**: API keys never committed to Git
✅ **Flexibility**: Easy to rotate keys
✅ **Team-friendly**: Each developer has their own key
✅ **Safe for public repos**: No credentials exposed
✅ **Clear errors**: Helpful messages if misconfigured
✅ **Automated setup**: Script for easy onboarding
✅ **Well documented**: Multiple documentation files
✅ **Best practices**: Industry-standard approach

---

**This architecture follows iOS security best practices and protects sensitive credentials! 🔐**
