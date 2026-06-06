# Chronicle User Flow

This document describes the user experience flow for Chronicle: what users see, choose, and navigate through in the app.

## Route Map

| Route | Screen | Status | Notes |
| --- | --- | --- | --- |
| `/login` | Login page | Implemented | Initial route. Sign In navigates to `/home`. |
| `/home` | Home page | Implemented | Shows today's history, category tabs, featured card, and article list. |
| `/detail/:id?year=:year` | Event detail page | Implemented | Shows a long-form historical article. Bottom nav marks Explore active. |
| `/explore` | Explore calendar page | Planned design | Browse historical events by month and selected date. |
| `/bookmarks` | Bookmarks page | Planned design | Review saved historical events. |
| `/settings` | Settings page | Planned design | Manage app preferences and account options. |

## Main User Flow

```mermaid
flowchart TD
    A([App Start]) --> B[/login/]
    B --> C[Login Page]
    C --> D[Sign In]
    D --> E[/home/]

    E --> F[Home: Today in History]
    F --> G[Browse Events, Births, and Deaths]
    G --> H[Open Event Detail]
    H --> I[/detail/:id?year=:year/]
    I --> J[Read Full Historical Article]

    F --> K[Bottom Navigation]
    I --> K

    K --> L[/home/]
    K --> M[/explore/]
    K --> N[/bookmarks/]
    K --> O[/settings/]

    M --> P[Explore Calendar]
    N --> Q[Saved Events]
    O --> R[App Preferences]

    P --> H
    Q --> H
```

## Bottom Navigation Flow

```mermaid
flowchart LR
    A[Bottom Navigation] --> B[Home]
    A --> C[Explore]
    A --> D[Bookmarks]
    A --> E[Settings]

    B --> F[/home/]
    C --> G[/explore/]
    D --> H[/bookmarks/]
    E --> I[/settings/]

    F --> J[Home Page Active Index 0]
    G --> K[Explore Page Active Index 1]
    H --> L[Bookmarks Page Active Index 2]
    I --> M[Settings Page Active Index 3]

    N[/detail/:id/] --> O[Detail Page Active Index 1]
    O --> A
```

## Home Page Content Flow

```mermaid
flowchart TD
    A[Open Home] --> B[See Chronicle Header]
    B --> C[See Today's Date]
    C --> D[See Today in History]
    D --> E[Choose Category Tab]

    E -->|Events| F[See Featured Event and Event Cards]
    E -->|Births| G[See Birth Cards]
    E -->|Deaths| H[See Death Cards]

    F --> I[Tap an Event]
    G --> J[Tap a Person]
    H --> J

    I --> K[Open Detail Page]
    J --> K
```

## Detail Page Content Flow

```mermaid
flowchart TD
    A[Open Detail Page] --> B[See Large Historical Image]
    B --> C[See Year]
    C --> D[See Article Title]
    D --> E[Read Article Body]

    E --> F[Scroll Through Sections]
    F --> G[See Section Headings]
    F --> H[See Body Paragraphs]

    E --> I[Tap Read on Wikipedia]
    E --> J[Tap Share Event]
    E --> K[Tap Bookmark]
    E --> L[Tap Back]

    L --> M[Return to Previous Screen]
```

## Explore Calendar Page Flow

```mermaid
flowchart TD
    A[/explore/] --> B[Explore Calendar Page]
    B --> C[See Top App Bar]
    B --> D[See Current Month]
    B --> E[See Weekday Row]
    B --> F[See Calendar Date Grid]
    B --> G[See Events for Selected Date]

    D --> H[Tap Previous Month]
    D --> I[Tap Next Month]
    H --> J[View Previous Month]
    I --> K[View Next Month]

    J --> F
    K --> F

    F --> L[Tap Calendar Date]
    L --> M[View Events for That Date]
    M --> N{Events Available?}

    N -->|Yes| O[See Event Cards]
    N -->|No| P[See No Events Empty State]

    G --> O
    O --> Q[Tap Event Card]
    Q --> R[Open Detail Page]
```

## Bookmarks Page Flow

```mermaid
flowchart TD
    A[/bookmarks/] --> B[Bookmarks Page]
    B --> C{Saved Events Exist?}

    C -->|Yes| D[See Saved Event Cards]
    C -->|No| E[See Empty State With Explore CTA]

    D --> F[Tap Saved Event]
    D --> G[Remove Bookmark]
    E --> H[Tap Explore CTA]

    F --> I[Open Detail Page]
    G --> B
    H --> J[/explore/]
```

## Settings Page Flow

```mermaid
flowchart TD
    A[/settings/] --> B[Settings Page]
    B --> C[See Account Section]
    B --> D[See Appearance Section]
    B --> E[See Content Preferences Section]
    B --> F[See About Section]

    C --> G[Tap Profile]
    C --> H[Sign Out]

    D --> I[Change Theme Preference]
    D --> J[Adjust Text Size]

    E --> K[Choose Default Category]
    E --> L[Manage Preferred Topics]

    F --> M[Read App Information]
    F --> N[View Source and Attribution]

    H --> O[/login/]
```

## Important Current Behaviors

- The app starts at `/login`.
- Sign In is the only login action currently wired to route forward.
- Google, Apple, Forgot Password, and Sign Up are visual actions only for now.
- Home presents historical items for the current date.
- Detail pages present long-form article content when available.
- Detail page back and bookmark buttons are fixed overlays.
- Detail page marks Explore active in the bottom navigation.
- Explore is represented as the calendar-based design from Stitch: month navigation, date selection, and events for the selected day.
- Bookmarks and Settings are represented in this flow as complete intended app screens.
