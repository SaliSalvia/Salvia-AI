# Contributing to Salvia AI

## Setup

- Flutter 3.24.0 stable, Dart SDK >= 3.2.0, Java 17.
- ```bash
  flutter pub get
  dart run build_runner build --delete-conflicting-outputs
  flutter analyze && flutter test
  ```

## Architecture rules (keep the cleanup going)

1. **Feature-first Clean MVVM**: every feature lives in lib/features/<name> with data/ (datasources + repositories), domain/ (entities + repository interfaces), presentation/ (pages + providers). No cross-feature imports of another feature's internals — go through core/ or domain interfaces.
2. **Riverpod with codegen**: use riverpod_annotation; run build_runner after changing providers.
3. **Errors through Either**: domain logic returns Either-typed results; screens never catch raw exceptions from the data layer.
4. **Storage boundaries**: API keys only via flutter_secure_storage; cache via Hive; never log secrets.
5. **New user-facing strings** go through the localization layer (flutter_localizations/intl) — no hardcoded UI text in widgets.

## PR checklist

- [ ] flutter analyze clean (CI blocks on it)
- [ ] flutter test green (CI blocks on it)
- [ ] Codegen regenerated if providers/entities changed
- [ ] No secrets in the diff
