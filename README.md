# Chronicle

Chronicle is a Flutter history app that helps users discover events, births, and deaths that happened on the current date. It uses an editorial dark visual style with amber accents, long-form article detail pages, and a bottom navigation experience inspired by the Stitch design system.

## Features

- Login screen with email/password UI and social sign-in buttons.
- Home screen for today's historical events.
- Category tabs for Events, Births, and Deaths.
- Featured historical event card.
- Article cards powered by Wikipedia On This Day data.
- Detail page with a large hero image, year, title, and long-form article content.
- Wikipedia article section-style headings inside detail content.
- Fixed back and bookmark buttons on the detail page.
- Bottom navigation for Home, Explore, Bookmarks, and Settings.
- Explore, Bookmarks, and Settings routes are available for future screen implementation.

## User Flow

The full user experience flow is documented in [`USER_FLOW.md`](USER_FLOW.md).

It includes:

- Overall app journey
- Home browsing flow
- Detail reading flow
- Explore calendar flow
- Bookmarks flow
- Settings flow
- Bottom navigation flow

## Routes

| Route | Description |
| --- | --- |
| `/login` | Entry screen and sign-in UI. |
| `/home` | Main Today in History feed. |
| `/detail/:id?year=:year` | Historical article detail page. |
| `/explore` | Explore calendar route. |
| `/bookmarks` | Saved events route. |
| `/settings` | App preferences route. |

## Tech Stack

- Flutter
- Dart
- GoRouter
- Google Fonts
- Flutter SVG
- HTTP package
- Wikipedia REST and MediaWiki APIs

## Project Structure

```text
lib/
  core/
    router/
    services/
    theme/
  features/
    auth/
    chronicle/
  shared/
    widgets/
```

## Getting Started

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Run static analysis:

```bash
flutter analyze
```

Build for web:

```bash
flutter build web
```

## Data Source

Chronicle uses Wikipedia data for historical content:

- On This Day feed for home screen event lists.
- Page summary metadata for detail title and imagery.
- Full text extracts for longer article detail content.

Items without linked Wikipedia pages are filtered out to avoid low-quality cards with missing images or weak titles.

## Design Direction

Chronicle follows a clean editorial style:

- Dark archival background
- Amber/gold active states and historical year highlights
- Serif headings with readable sans-serif body text
- Full-width image-led detail pages
- Rounded cards and pill-shaped navigation/buttons
