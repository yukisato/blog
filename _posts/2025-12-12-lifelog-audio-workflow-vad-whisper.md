---
title: "Building My Lifelog Audio Workflow (Silero VAD + Whisper) — Anchor"
date: 2025-12-12 18:50:00 -0800
categories: [AI, Life Logging]
tags: [lifelog, audio, transcription, whisper, vad, silero, syncthing, workflow]
description: "An anchor post for my local-first lifelog pipeline: Android recording → Syncthing → local VAD + Whisper → daily JSONL → AI summarization."
pin: true
---

## TL;DR

I’m building a local-first lifelog system: record my day with a mouth mic, segment speech with **Silero VAD**, transcribe with **Whisper**, and store results as daily **JSONL** for AI summarization. This post is the **anchor/index** for the series and will link out to future snapshot updates.

---

## Current system diagram

```text
+---------------------------+
| Android phone             |
| - Smart Voice Recorder    |
|   (VAD off, mono 16 kbps) |
+-------------+-------------+
              |
              | Syncthing (when home)
              v
+---------------------------+
| Ubuntu desktop            |
| 1) Receive (Syncthing)    |
| 2) Detect + queue         |
|    (Watcher)              |
| 3) Segment speech         |
|    (Silero VAD)           |
| 4) Transcribe             |
|    (Whisper)              |
| 5) Write daily JSONL      |
+---------------------------+
```

---

## About this post (Anchor / Index)

This is the **anchor post** for a small series. I’ll publish short “snapshot” updates as I iterate, and once the system reaches what I consider **release-level quality**, I’ll write a public “roundup” post that links back to the key snapshots.

> Personal note: I’m writing this down now because I’m heading on vacation tomorrow and wanted to capture the current state before I go.

- **Series tag**: [`/tags/lifelog/`](/tags/lifelog/)
- **Category**: [`/categories/life-logging/`](/categories/life-logging/)

### Upcoming snapshot posts (I’ll keep this list updated)

- [ ] VAD threshold tuning: false positives / misses
- [ ] Recovery/resume strategy for long Whisper runs
- [ ] Daily JSONL merge + schema decisions
- [ ] Summarization policy + automation
- [ ] (Optional) webrtcvad comparison

---

## Three key learnings so far

At this stage, the biggest “glad I learned this early” lessons are:

1. **Protect the timeline (don’t use silence-skip)**
   - Silence-skip makes files smaller, but it becomes hard to reconstruct *when* something was said.
   - For lifelogging, “being able to review later” is the value, so I’m prioritizing a stable, real timeline.

2. **Simplicity beats perfection (standardize on JSONL)**
   - Instead of adding extra conversion layers (like TXT), it’s easier to operate if Whisper outputs are organized as **daily JSONL**.
   - For summarization, I’ll start by letting the AI reference JSONL directly, then iterate only if needed.

3. **Assume long jobs will fail (design for recovery)**
   - It’s normal for processing runs (e.g., 12 hours of audio) to stop mid-way.
   - So I’m structuring the pipeline around “segments / days / output format” so it can resume safely.

---

## Goal

- Record a full day of speech with a mouth mic → **high-quality transcription**
- Feed the results to an AI to drive **habit improvements** and **skill growth**

## Background

- I was inspired by the lifelog experience of the Limitless AI Pendant and wanted to build my own.
- I also heard concerns about accuracy, so I decided to build on **Whisper** locally.
- Since I have a powerful Ubuntu desktop, I’m prioritizing a **local-first** implementation.

---

## Current workflow (Silero VAD + Whisper)

At a high level, this is the pipeline:

1. **Recording**
   - Format: **16 kHz / mono / PCM WAV**
   - Policy: **silence-skip OFF** (preserve the timeline)
   - Why: Whisper internally resamples to **16 kHz mono PCM** anyway, so recording in the minimum required format keeps files smaller. Silence-skip stays OFF to preserve the real timeline.

2. **Sync**
   - Continuous WAV recording → auto-sync to desktop via **Syncthing**
   - Why: This contains personal data, so I want local processing. Running Whisper Large v3 in the cloud would get expensive, and auto-sync makes the workflow feel “always-on” (closer to the convenience of products like the Pendant).

3. **VAD**
   - Extract speech segments with **Silero VAD**
   - Why: Phone-side VAD can break timing. I run VAD locally so I can keep a stable timeline and still detect speech segments with a timeline-aware approach (Silero).

4. **Transcription**
   - Send extracted segments to **Whisper**
   - Store outputs as **daily JSONL**
   - Why: I use **Whisper large-v3** for the highest local accuracy. Daily JSONL is easy for an LLM to consume for daily summaries, and later I can build “bigger scope” summaries (weekly/monthly) by referencing the smaller summaries.

5. **AI summarization**
   - Have the AI reference daily JSONL directly (starting manual/semi-auto)
   - Why: In Cursor, I want to quickly switch models, inspect outputs, and converge on the best summarization policy before investing in a heavier data store/UI.

### Rough storage footprint

- **~1.5 MB/min**
- **~1.8 GB for 12 hours**

---

## Current issues (sticking points)

- **Recovery after interrupted Whisper runs** (reuse partial progress)
- **Daily JSONL merge** (operational foundation)
- **Summarization policy** (start with direct JSONL reference)
- **Automating summarization** (final step toward stable ops)

---

## Next actions

- [ ] Validate VAD→Whisper: check false positives/misses, tune thresholds
- [ ] Compare with webrtcvad if needed
- [ ] Design the summarization flow

---

## “Release-level” checklist (draft)

The goal of this series isn’t merely “it runs” — it’s **something I can operate daily**. My current “release-level” bar looks like this:

- **Repeatability**: I can run a full-day pipeline (e.g., 12 hours) end-to-end with a consistent procedure
- **Recoverability**: If Whisper/GPU jobs stop mid-run, I can **resume safely** by segment/day
- **Quality control**: I can measure VAD misses/false-positives and have a tuning process
- **Data design**: JSONL schema is stable, and daily merges don’t break
- **Automation**: Sync → processing → summarization is automated enough to be “hands-off”

Once this is true, I’ll write a **public roundup post** that links to the most important snapshot posts.

---

## Development log

| Date | Notes |
| --- | --- |
| 2025/12/12 | Dropped the TXT layer. New plan: merge JSONL by day → have the AI reference JSONL directly for a simpler system. |
| 2025/12/07 | Verified long recording stability (battery/storage/background). No issues. |
| 2025/12/06 | Switched to passing VAD segments directly to Whisper in memory to reduce I/O. Input 7h46m → small: 317s (~88× realtime), large-v3: 486s (~57× realtime). |
| 2025/12/06 | Updated VAD→Whisper processing to run as a single GPU batch. |
| 2025/12/05 | Decided against silence-skip because reconstructing realtime is difficult. |
| 2025/12/05 | Moved to: Smart Recorder (silence-skip OFF) + Syncthing. Use Silero VAD to detect segments while preserving timeline → Whisper full transcription. |
| 2025/12/04 | Built an automated flow: Smart Recorder (silence-skip) → Syncthing auto-sync → processing pipeline. |
| 2025/12/04 | Built a prototype for WAV → Whisper transcription. |
| 2025/12/03 | Started the project. Fixed VRAM pressure from keeping the model loaded by unloading after each run and loading only when needed (SSD makes overhead small). |


