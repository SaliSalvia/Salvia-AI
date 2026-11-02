# Security Policy — Salvia AI

## Supported versions

The main branch is the only supported version. CI builds release APKs from main.

## What is in place

- **API keys at rest**: flutter_secure_storage (platform Keychain/Keystore).
- **No secrets in source**: the app asks for the key at runtime; .env and keys are never committed.
- **Local-first**: no backend, no user accounts — the attack surface is the device and the provider API.
- **Networking**: dio over HTTPS.

## Reporting a vulnerability

Open a **private security advisory** in this repository (Security tab → Report a vulnerability). Include:

1. App version (pubspec version + commit).
2. Steps to reproduce or proof of concept.
3. Impact assessment.

Do not open public issues for exploitable vulnerabilities.

## Hardening backlog (tracked for release readiness)

- Release signing: CI currently builds unsigned release APKs; a protected keystore is required before distribution.
- Dependency review: pin and audit Dio/Hive/Coil plugin versions each release.
- Consider certificate pinning for the configured AI provider endpoint.
