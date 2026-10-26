# Luto (Logo: Lu2) 🍳
> **Universal, Community-Driven, Offline-First Mobile Cooking Platform**

[![Status: Architecture Finalized](https://img.shields.io/badge/Status-Architecture%20Finalized-2ea44f.svg)](#)
[![Stack: React Native + Expo](https://img.shields.io/badge/Mobile-React%20Native%20%7C%20Expo%20SDK%2051%2B-blue.svg)](#)
[![Database: Supabase + WatermelonDB](https://img.shields.io/badge/Database-PostgreSQL%20%2B%20WatermelonDB%20(SQLite)-00C7B7.svg)](#)

---

## 📖 Overview

**Luto** (branded as **Lu2**, derived from the universal root for cooking / culinary preparation) is a community-driven, cross-platform mobile cooking application engineered for high kitchen resilience, zero-network operational capability, and intelligent pantry management.

Kitchens are notorious network dead zones (faraday cage refrigerators, basement apartments, remote outdoor cooking). Luto is architected from the ground up as an **offline-first** kitchen companion that turns available ingredients into delicious meals while reducing food waste.

---

## 🌟 Core Pillars

1. **Offline-First Kitchen Resilience**:
   - Zero-latency local SQLite operations via **WatermelonDB** (JSI).
   - Local pre-caching of step instructions, high-resolution WebP hero images, and silent looping technique micro-videos.
   - Bidirectional delta synchronization with Last-Write-Wins (LWW) monotonic server timestamp conflict resolution.

2. **"What's in My Fridge?" Pantry Engine**:
   - Mathematical culinary-aware matching score with universal staple exemptions (oil, salt, pepper, water).
   - Tiered ingredient weighting (Core proteins/starches: $w=3.5$; Secondary vegetables/aromatics: $w=2.0$; Finishing/garnishes: $w=0.8$).
   - Dynamic pantry deduction upon recipe completion.

3. **Dynamic Culinary Substitution Engine**:
   - Context-aware rule-based mapping (baking vs. sautéing vs. boiling vs. raw dressings).
   - Precise arithmetic conversion ratios ($Q_{\text{new}} = Q_{\text{original}} \times \text{ratio}$).
   - Sensory impact warnings (flavor profile shifts, texture changes, curdling prevention).

4. **Distraction-Free Cooking Mode**:
   - High-contrast, large-format typography (24sp+) readable from 1.5 meters away on a kitchen counter.
   - Screen wake-lock (`expo-keep-awake`) preventing sleep during active cooking.
   - Multi-timer concurrent background engine with audio/haptic alarms.
   - Prerequisite technique micro-tutorial callouts (6-second looping videos).

5. **Universal Community CRUD Platform**:
   - Multi-step structured recipe creator with canonical ingredient auto-complete.
   - Automated content moderation gates and sanity checks.
   - Verified "Cooked It!" community reviews and Bayesian rating calculation.

---

## 📂 Architecture & Technical Specifications

Comprehensive engineering documentation and seed data are maintained in the [`docs/`](docs/) directory:

- 📐 **[System Architecture Specification](docs/system-architecture.md)**:
  - Framework evaluation (React Native / Expo vs. Flutter).
  - Supabase PostgreSQL 16 schema, Storage buckets, and Row Level Security (RLS) policies.
  - Complete Relational Entity Relationship Diagram (ERD) & PostgreSQL DDL.
- ⚙️ **[Feature & Engine Specification](docs/feature-spec.md)**:
  - "What's in My Fridge?" matching algorithm formulas and TypeScript pseudocode.
  - Dynamic substitution resolver pipeline.
  - WatermelonDB local database architecture & media pre-caching pipeline.
  - Kitchen cooking mode UX specification and submission state machines.
- 🗄️ **Universal Culinary Taxonomies**:
  - **[`docs/taxonomies/substitutions.json`](docs/taxonomies/substitutions.json)**: 35 standardized ingredient swaps across 6 categories.
  - **[`docs/taxonomies/equipment.json`](docs/taxonomies/equipment.json)**: 32 essential vs. specialized kitchen equipment items with workarounds.
  - **[`docs/taxonomies/techniques.json`](docs/taxonomies/techniques.json)**: 20 core culinary techniques structured for in-app micro-tutorials.
- 🗺️ **[Phased Engineering Delivery Roadmap](docs/roadmap.md)**:
  - Milestone 1: Schemas, Migrations & Taxonomies.
  - Milestone 2: Backend API, Supabase Auth & Storage RLS.
  - Milestone 3: Mobile Core UI, Offline Sync & Pantry Engine.
  - Milestone 4: Community Upload, Ratings & Interactive Cooking Mode.

---

## 🛠️ Technology Stack

| Layer | Technology | Purpose |
| :--- | :--- | :--- |
| **Mobile Client** | React Native (Expo SDK 51+) | Cross-platform iOS & Android mobile application |
| **JS Engine** | Hermes | Fast startup, small footprint, ahead-of-time compilation |
| **Local Offline DB** | WatermelonDB (SQLite via JSI) | Reactive, lazy-loaded local database for zero-latency kitchen access |
| **Media Caching** | `expo-image` + `expo-file-system` | Persistent disk LRU cache for step photos and technique video loops |
| **Backend & Database** | Supabase (PostgreSQL 16) | Relational database, PostgREST API, Edge Functions, Row Level Security |
| **Authentication** | Supabase Auth | OAuth (Google, Apple), Email/Password, Anonymous Guest Mode |
| **Media Storage** | Supabase Storage (S3 + CDN) | Scalable media hosting for recipe hero images and technique micro-clips |
| **State Management** | Zustand + TanStack Query v5 | Lightweight client state & server synchronization |

---

## 📜 License & Governance

Universal culinary specifications and schemas developed for the Luto Open Culinary Platform.
Repository: [https://github.com/d-Lucx/Luto](https://github.com/d-Lucx/Luto)

## Mobile implementation

The Expo client lives in [`apps/mobile`](apps/mobile/README.md). It includes
WatermelonDB models, a local pantry screen, and the tested pantry evaluation
engine. See its README for setup, current verification limits, and remaining
sync/media work.
