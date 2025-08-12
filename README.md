# Woodwright — Woodworking Project Planner (MVP)

**Goal:** Convert rough project ideas into safe, build-ready plans in minutes: dimensions → materials → joinery → cut list → build steps.  
**Platforms:** iOS & Android (Flutter). **Mode:** Offline-first. **Units:** Imperial default, metric optional.

## Why this exists
Many DIY woodworkers struggle with: material estimates, safe joinery choices, and converting designs into optimized cut lists. Woodwright streamlines those steps with deterministic, on-device calculators.

## MVP Features (snapshot)
- Project templates (Bookshelf, Table, Base Cabinet)
- Material estimator (rough lumber + sheet goods) with ~10% waste allowance
- Joinery engine with **safety enforcement** (blocks unsafe options)
- Cut list + layout optimizer (kerf & grain respected) with DXF/SVG preview
- Exports: PDF/CSV (MVP), SketchUp/DAE as a paid upgrade later
- Local project storage (no account required)

## Learn more
- Full spec: [`docs/SPEC-1-Woodworking-Planner-App.md`](docs/SPEC-1-Woodworking-Planner-App.md)

## Tech
- Flutter + Riverpod
- Drift (SQLite) for offline data
- `pdf`/`printing` for exports, `dxf` for 2D
- Deterministic, on-device calculators

## Repo structure (initial)
```
docs/                                # Specs and design docs
lib/                                  # Flutter code (to be added)
  core/ data/ domain/ features/ ui/   # See spec for structure
.github/                               # Templates/Workflows
```

## Getting Started (dev)
1. Install Flutter (stable) and Dart per upstream docs.
2. Create the Flutter app or open your existing app.
3. Copy files from this bundle into your repo root.
4. Commit and push.

## License
MIT © 2025 Edward Saldana
