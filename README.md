```text
             .,.................;,
           ,,.                .:.
          ,.   ,,..........,:,,
        .,    .:.                      .,.:,
        ,.          . ....,,          ,, ,,
         ,,...........    .: :,,,.., .. ,. .:,,,,.:....,...:
                   .:,   ,:..:,,:  ,,. ,  .,,,,:. ,:. ,,,,,
     ................   ,,,..,,, .,,. :.....,,:  ,,  :.
   ,,.                .,.,. ,,,..::,...:;, .,,..,:..:
 .,.  ...,...,,,,,,,,,,. :,,,,,,..,.,.,..,,........,
.;::;:::.  .,,,,,,,,,...,....,;.
         .,.                .:.
        ,,   .,..........,::,       ....          ..
       ,.    ,,........,  .        .,.:.        .:.:.
       ,,      .       .;. ,,,.,, .: ,,,,, .,.:.,:;..,,,.,,
        ,,........:.   .:.::,:: ,;, :.,, ;,,.,;, ,, ::::: :,
     .............,   ,:,,,,:, .;, :. ,. :,.,:, ,,,,,,:, .,
   ,,....            ::,. :::  ;:  ,;.,,  ,,,, ,;,. :,: .:
 ,,.   ............,, .,.,.,,.,,.,.,,  :.,. :.,,,,...,,.,,
;+::;;:,..........
```

# Salvia AI v4 - World-Class Flutter App

Premium AI chat and image studio app with Clean Architecture.

## Setup & Build

1. Upload all files to a new GitHub repository
2. Go to the "Actions" tab
3. The "Build Salvia AI APK" workflow runs automatically
4. Download `salvia-ai-apk` from Artifacts

## Architecture

- Clean MVVM + Riverpod
- Feature-first folder structure
- fpdart Either types for error handling
- Hive for local cache, flutter_secure_storage for API keys

# Salvia AI v4 — Premium AI Chat & Image Studio (Flutter)

Premium AI chat and image studio app for Android and iOS, built with Clean Architecture. Part of the Sali/Salvia AI project family (siblings: Personal-AI---HCN — flagship native workspace · Sali-ZZZ — Z.ai native client · SaliX-ai — experiment bed).

> **Status: MVP-level.** Core features work and CI builds APKs; see the [Product Readiness Scorecard](docs/PRODUCT_READINESS_SCORECARD.md) for the honest gap list (QA gates, localization, release pipeline, product differentiation).

## Features

- 💬 **AI chat** with streamed responses
- 🎨 **Image studio** — generation with gallery/viewer (image_picker, photo_view)
- 🔑 **Local-first API setup** — "auth" means entering your own API key, stored in flutter_secure_storage; no user accounts, no backend
- ⚙️ **Settings** with provider configuration
- ✨ Premium UI kit: glass morphism widgets, staggered animations, shimmer, Lottie, Google Fonts

## Architecture

- **Clean MVVM + Riverpod** (riverpod_annotation + codegen)
- **Feature-first structure**: `lib/features/{auth,chat,image_studio,settings,splash}` each with data/domain/presentation
- **core/**: constants, errors, localization, painters, providers, services, theme, utils, widgets
- **Errors**: fpdart-style Either handling in domain layer
- **Storage**: Hive (cache) · flutter_secure_storage (API keys) · shared_preferences (flags)
- **Networking**: dio

## Build

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run             # debug on device
flutter build apk --release --split-per-abi
```

CI (Actions tab) builds a release APK per ABI on every push to main. Flutter 3.24.0 stable · Java 17.

## Testing

```bash
flutter analyze
flutter test
```

Existing suites: chat domain entities, haptics utility, core widget tests. CI runs both; both are blocking.

## Documentation

| Document | Contents |
| --- | --- |
| [Product Readiness Scorecard](docs/PRODUCT_READINESS_SCORECARD.md) | Readiness assessment + 30/60/90 plan (QA, l10n, release pipeline, differentiation) |
| [Privacy Policy](PRIVACY.md) · [Security Policy](SECURITY.md) | Legal and security policies |
| [Contributing](CONTRIBUTING.md) | Architecture rules, PR checklist |
