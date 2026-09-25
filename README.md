# Info Tech Crash Courses

Short (30–50 min) internal courses and workshops on topics that seem hard until
someone explains the basics in plain words. Each course has slides, a take-home
handout and hands-on exercises. Most courses come in English and Dutch.

## Courses

| # | Course | Status | EN | NL |
|---|--------|--------|----|----|
| 01 | **Crypto basics: locks, keys, seals & passports** | 🟢 draft | [README](courses/01-crypto-basics/README.md) · [slides](courses/01-crypto-basics/slides.qmd) | [README](courses/01-crypto-basics/README.nl.md) · [slides](courses/01-crypto-basics/slides.nl.qmd) |
| 02 | **TLS & PKI in practice: HTTPS and beyond** | 🟢 draft | [README](courses/02-tls-and-pki/README.md) · [slides](courses/02-tls-and-pki/slides.qmd) | [README](courses/02-tls-and-pki/README.nl.md) · [slides](courses/02-tls-and-pki/slides.nl.qmd) |
| 03 | **Git: a time machine made of sticky notes** | 🟢 draft | [README](courses/03-git/README.md) · [slides](courses/03-git/slides.qmd) | [README](courses/03-git/README.nl.md) · [slides](courses/03-git/slides.nl.qmd) |
| 04 | Bash for the rest of us | ⚪ optional, future | [outline](courses/04-bash-for-the-rest-of-us/README.md) | |

The rendered slides and pages are published to GitHub Pages (see
[Publishing](#publishing)).

## Following a course (students)

👉 **[Joining a course](joining.md)** · 🇳🇱 **[Meedoen aan een cursus](joining.nl.md)**

In short: explainers need nothing but a pen. Builders open the exercise
**sandbox**, a small Linux environment with OpenSSL, Python and the other tools
installed, through GitHub Codespaces, VS Code + Docker Desktop, or plain
Docker. They check it with `bash "$COURSES/tools/ready.sh"`. Exercises write to
`~/lab/<course>` and never into the repo.

## Presenting a course (facilitators)

Slides are written in Markdown and rendered with [Quarto](https://quarto.org)
to [reveal.js](https://revealjs.com) HTML. Diagrams are [Mermaid](https://mermaid.js.org).

```bash
quarto preview courses/01-crypto-basics/slides.qmd     # live preview in the browser
quarto render                                          # whole site into _site/
```

Useful keys in the slides: `S` for speaker view with notes, `F` for full screen,
`O` for the slide overview, `E` for PDF-export layout (then print to PDF from the browser).

For a single portable HTML file that works offline, add `embed-resources: true`
to the slide's front matter, or run
`quarto render <slides.qmd> --to revealjs -M embed-resources:true`.

## Repository layout

```
.
├── courses/NN-topic/          one folder per course, same shape each time
│   ├── README(.nl).md         audience, goals, timed agenda, facilitator notes
│   ├── slides(.nl).qmd        the deck, with speaker notes
│   ├── handout(.nl).md        one-page take-home
│   ├── cheatsheet(.nl).md     commands at a glance
│   ├── exercises/             worksheets (*.md), scripts, check.sh
│   └── solutions/             facilitator answers
├── _template/                 copy this to start a new course
├── shared/                    slide theme, metaphors, EN↔NL glossary
├── sandbox/Dockerfile         the student sandbox image
├── .devcontainer/             Codespaces / VS Code Dev Container config
├── tools/                     exercise smoke tests, translation checks
└── .github/workflows/         publish to Pages, test exercises
```

## Look and feel

Slides and pages follow the [info.nl](https://www.info.nl/) look: Outfit and
Playfair Display, deep teal and mint, → bullets and the green wave. It's all
in [shared/_brand.scss](shared/_brand.scss); see
[CONTRIBUTING.md](CONTRIBUTING.md#look-and-feel-info-brand).

## Languages

English is the source. Dutch versions sit next to it with a `.nl` suffix
(`slides.nl.qmd`, `README.nl.md`, …). Commands, code, config and tool output
stay in English in both versions, because that is what people see in the
software and the docs. See [shared/glossary.md](shared/glossary.md) for which
terms we translate and which we keep in English.

## Publishing

Every push to `main` renders the site and deploys it to GitHub Pages
([publish.yml](.github/workflows/publish.yml)). Enable it once under
*Settings → Pages → Source: GitHub Actions*.

> ⚠️ On a public repo, the Pages site is public too. For internal-only
> visibility, use a private repo on GitHub Enterprise Cloud with private Pages,
> or skip Pages and share the rendered HTML files.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md), and start new courses from [_template/](_template/).

```bash
make test          # run every course's exercises and self-checks, check NL/EN commands match
```
