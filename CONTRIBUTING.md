# Contributing a course

## Principles

1. **Explain it like I'm five, then add the real word.** Every concept gets one
   everyday metaphor first ("an open padlock you hand out") and only then the
   jargon ("public key"). Reuse the metaphors in
   [shared/metaphors.md](shared/metaphors.md) so courses build on each other,
   and say where a metaphor breaks down.
2. **30–50 minutes, no more.** Roughly 20–25 min of talking, 15–20 min of
   exercises, 5–10 min of debrief. If a topic doesn't fit, split it into two
   courses.
3. **Two tracks where it makes sense.**
   - 🗣 **Explainers** don't use a terminal. They have to explain *why*, *who*
     and *what* to clients and colleagues. They get tabletop scenario cards and
     a handout.
   - 🛠 **Builders** get terminal exercises in the sandbox.

   Both tracks finish with a shared debrief.
4. **One take-home page.** The handout is what people keep. Everything they need
   to do their job after the course should be on it.
5. **No real secrets, ever.** Exercises generate their keys at runtime in
   `~/lab/<NN>`. Nothing that looks like a real key or certificate goes into git
   (see `.gitignore`).

## Adding a course

```bash
cp -r _template courses/04-my-topic
```

Then:

1. Fill in the header table in `README.md`: duration, audience, prerequisites,
   goals and agenda.
2. Write `slides.qmd`. Put speaker notes in `::: notes` blocks.
3. Write the exercises and `exercises/check.sh`.
4. Add the course to the catalogue in [README.md](README.md) and [index.qmd](index.qmd).
   If it needs more tools than the sandbox has, add them to `sandbox/Dockerfile`
   and to the checks in `tools/ready.sh`.
5. Run `make test`.

## Exercise conventions

These rules let the smoke test (`tools/run-exercises.sh`) run the exercises for
you, so they don't silently stop working:

- Worksheets are named `NN-name.md` and are run in order.
- A fenced block marked **` ```bash `** is **run by the smoke test**. Keep these
  blocks non-interactive (no password prompts, no editors, no `less`).
- Use **` ```shell `** for commands students should run but CI should skip
  (interactive or slow ones). Use **` ```text `** for expected output.
- Keep code fences at the start of the line (not indented inside lists).
- Step 1 of the first worksheet creates and enters the lab folder:
  `mkdir -p ~/lab/NN && cd ~/lab/NN`. Later worksheets start with `cd ~/lab/NN`.
- Reach files in the repo through `$COURSES`, for example
  `python3 "$COURSES/courses/01-crypto-basics/exercises/aead_demo.py"`. The
  sandbox and dev container set this variable for you.
- `exercises/check.sh` only *reads* the lab folder and prints ✅/❌ with a hint.
  It exits non-zero if something is missing. Mark bonus checks as skippable.

## Translations (Dutch)

- English is the source. A translation is a sibling file with `.nl` before the
  extension: `slides.nl.qmd`, `01-fingerprints.nl.md`.
- Put a language switch at the top of each file:
  `🇬🇧 [English](x.md) · 🇳🇱 Nederlands`.
- Translate the prose. **Keep commands, code, code comments, file names, config
  and tool output in English.** Code blocks must be **identical** to the English
  version. `tools/check-translations.sh` fails if the ` ```bash ` blocks
  differ, which catches a translation that fell behind.
- For terminology, follow [shared/glossary.md](shared/glossary.md). On first
  use, give the Dutch word with the English term in brackets, then use the
  term people will actually see in e-mails and files.
- Facilitator material (`solutions/`) is English only.
- Slides in Dutch set `lang: nl` in their front matter, so Quarto's own labels
  are Dutch too.

## Slides

- Use Quarto reveal.js: `format: revealjs` with the shared theme
  `../../shared/theme.scss`.
- For diagrams, use `{mermaid}` cells. GitHub doesn't render `{mermaid}` in
  plain `.md` files, so keep diagrams in the slides and use tables in handouts.
- Start every **flowchart** with this line, or its labels get clipped inside reveal.js
  (HTML labels don't scale with the slide):
  `%%{init: {"htmlLabels": false, "flowchart": {"htmlLabels": false}}}%%`.
  Sequence diagrams don't need it.
- Before a session, check the whole deck: open it with `?print-pdf` in the
  browser, or export it with
  `docker run --rm -v "$PWD/_site":/site ghcr.io/astefanutti/decktape reveal file:///site/courses/NN-topic/slides.html /site/slides.pdf`.
- Aim for about one slide per minute of talking, and one idea per slide.
- Preview with `quarto preview path/to/slides.qmd`.
