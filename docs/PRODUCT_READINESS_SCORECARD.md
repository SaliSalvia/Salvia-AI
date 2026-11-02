# Product Readiness Scorecard — Salvia AI (Flutter)

_Assessment date: 2026-11-02 · Focus (per product review): architecture cleanup, QA, localization, release pipeline, product differentiation_

## Overall verdict

**MVP — mid.** The cleanest architecture of the four repos on paper (feature-first Clean MVVM, codegen, Either error handling), with a working CI that even analyzes and tests. The problem: the CI quality gates were non-blocking (`|| true`) so failures were invisible — fixed in this pass. Localization scaffolding exists (flutter_localizations, intl) but no .arb translation files. Release pipeline has no signing, no changelog, no store assets.

| Dimension | Score | Status |
| --- | --- | --- |
| UX/UI (premium kit, animations, glass) | 7/10 | Good; needs empty/error/loading state audit |
| Architecture (feature-first clean layers) | 8/10 | Good — keep the discipline in new features |
| Automated tests (3 suites) | 4/10 | Real but thin: no repository/provider/chat-flow tests |
| CI/CD (analyze + test + split-ABI APK) | 6/10 | Gates now blocking (this pass); no signing/coverage |
| Security & privacy (secure storage, BYOK) | 7/10 | Good; policies added in this pass |
| Localization | 3/10 | Scaffolding only — no arb files, no RTL proof |
| Onboarding | 5/10 | API setup page exists; first-run flow undocumented |
| Analytics/observability | 2/10 | None |
| App store readiness | 3/10 | No signing, listing assets or data safety form |
| Product differentiation | 5/10 | "Premium AI chat + image studio" — needs a sharper wedge vs the flagship apps |

## Differentiation question (the most important item)

The family already has a flagship multi-provider workspace (Personal-AI---HCN). Salvia AI must answer: **who is it for, that the flagship is not for?** Candidates to validate:

1. The consumer/creative audience that wants image-first workflows (image studio as the hero, chat secondary).
2. The audience that wants a beautiful, no-setup experience — "the friendly one" vs the pro tool.
3. iOS reach (the only sibling that can ship iOS today).

Pick one, write it into this scorecard, and cut features that do not serve it.

## 30 / 60 / 90-day plan

### Days 0–30 — QA truth + release pipeline
1. CI gates blocking (done in this pass). Fix anything they surface.
2. Coverage: tests for auth repository (secure storage flows), chat state provider (streaming start/stop/error), settings persistence.
3. Release signing: keystore + CI secrets; version strategy from pubspec version (1.0.0+1).
4. CHANGELOG.md + tag-based releases.

### Days 31–60 — Localization & store readiness
1. Real l10n: l10n.yaml + arb files (EN, FA first — RTL via Directionality already feasible), remove the `gen-l10n || true` workaround.
2. Empty/loading/error/retry states audit across all five features.
3. Store assets: icon pass, screenshots EN+FA, descriptions, data safety form from PRIVACY.md.
4. iOS smoke build (the family's only iOS-capable repo).

### Days 61–90 — Differentiation & beta
1. Ship the chosen differentiation wedge (see above).
2. Closed beta group + staged rollout.
3. Accessibility pass: semantics labels, contrast, font scaling (textScaler), large touch targets.
4. Performance profiling on low-end Android: image studio scrolling, chat streaming.
