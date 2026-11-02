# Privacy Policy — Salvia AI

_Last updated: 2026-11-02_

Salvia AI ("the app") is a Flutter AI chat and image studio application. It is **local-first**: no user accounts, no backend server, no analytics.

## Summary

- **No accounts.** "Auth" in this app means entering your own API key — it is stored on your device only.
- **Your API key is encrypted at rest** with flutter_secure_storage (Android Keystore-backed).
- **Chats, images and settings stay on your device** (Hive cache, app-private storage).
- **No tracking, no ads.** The app has no analytics SDK.
- **Uninstalling deletes everything** the app stored.

## Data stored on your device

| Data | Where | Purpose |
| --- | --- | --- |
| API key(s) | flutter_secure_storage (encrypted) | Authenticate your AI provider requests |
| Chat history & cache | Hive (app-private) | Local conversation history |
| Settings & flags | shared_preferences / Hive | App configuration |
| Generated images | App-private storage | Image studio gallery |

## Data that leaves your device

Only the requests you explicitly make: chat messages and image-generation prompts sent directly from your device to the AI provider you configured, using your key. Those requests are governed by the provider's own terms and privacy policy. The app never proxies through another server and never shares your data with anyone else.

## Permissions

The app requests permissions only when a feature needs them (e.g. image_picker for the studio). No contacts, location, microphone or background access.

## Children

The app is not directed at children under 13.

## Contact

Open an issue in this repository for privacy questions about the app's behavior.
