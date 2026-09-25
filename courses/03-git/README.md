🇬🇧 English · 🇳🇱 [Nederlands](README.nl.md)

# 03 · Git: a time machine made of sticky notes

| | |
|---|---|
| **Duration** | 45–50 min |
| **Audience** | Everyone who works with code, configuration or documentation in git, or with people who do: developers, testers, designers, project managers, release managers |
| **Tracks** | 🗣 **Explainers**: no terminal, scenario cards · 🛠 **Builders**: git in the sandbox |
| **Prerequisites** | None. Helpful: the idea of a fingerprint (hash) from [01 · Crypto basics](../01-crypto-basics/README.md). Builders: the sandbox ready, see [Joining a course](../../joining.md). |
| **Follow-up** | — |

## After this session you can…

**Everyone**

1. Explain why git exists, what came before it, and why it won.
2. Explain that git is **snapshots named by their fingerprint**, and that
   branches, tags and `HEAD` are just **labels** pointing at them.
3. Explain branches, merges, rebase, squash, cherry-pick and pull/merge
   requests in plain words, and choose a merge strategy and a branching strategy.
4. Explain the golden rule, *never rewrite history someone else may already have*,
   and why that means **fix forward** and **no force-push on shared branches**.
5. Say what to do first when a secret was committed.

**🗣 Explainers, in addition**

6. Advise a team on branching and merge strategy, and on handling a bad
   release or a leaked secret, without touching a terminal.

**🛠 Builders, in addition**

6. Look inside commits, merge and resolve a conflict, rebase, squash,
   cherry-pick, rescue work with the reflog, revert, and see what `--force` does to a team.

## Agenda

| Time | Part | Slides |
|------|------|--------|
| 0–3 | Hook: *"I'll just force-push main to clean it up"*, and git in one slide | 1–4 |
| 3–9 | **Part 1 · Why git**: before git, the predecessors, why git won | 5–8 |
| 9–15 | **Part 2 · Under the hood**: snapshots, fingerprints, labels, diffs, remotes | 9–14 |
| 15–22 | **Part 3 · Working together**: branch, merge, conflicts, rebase, squash, cherry-pick, pull requests, strategies | 15–23 |
| 22–27 | **Part 4 · The permanent record**: the golden rule, force-push, fix forward, reflog, secrets, audit trail | 24–32 |
| 27–43 | **Exercises**, pick your track | 33 |
| 43–50 | **Debrief**: one scenario card, everyone together | 34 |

## Materials

| | For | What |
|---|---|---|
| [slides.qmd](slides.qmd) | everyone | the deck, speaker notes included (`S` in the browser) |
| [handout.md](handout.md) | everyone, **print it** | safe vs dangerous commands, merge and branching strategies, first aid, leaked-secret procedure |
| [cheatsheet.md](cheatsheet.md) | 🛠 | the git commands from the exercises, and more |
| [exercises/tabletop-git-in-a-team.md](exercises/tabletop-git-in-a-team.md) | 🗣 | scenario cards, one set per pair |
| [exercises/01-under-the-hood.md](exercises/01-under-the-hood.md) … [05-bonus-collaboration-force-push.md](exercises/05-bonus-collaboration-force-push.md) | 🛠 | terminal worksheets; `check.sh` checks your work |
| [solutions/](solutions/tabletop-answers.md) | facilitator | answers and discussion notes ([tabletop](solutions/tabletop-answers.md), [builders](solutions/builders.md)) |

## Exercises

**🗣 Explainers** work in pairs on the
[scenario cards](exercises/tabletop-git-in-a-team.md). Aim for 3–4 of the 7 cards.

**🛠 Builders** work through the worksheets in order; each one continues in
the same repository. 1–4 are the core (about 18 min); 5 is a bonus.

| # | Worksheet | Time |
|---|-----------|------|
| 1 | [Under the hood: photos and sticky notes](exercises/01-under-the-hood.md) | 4 min |
| 2 | [Branches and merges](exercises/02-branches-and-merges.md) | 5 min |
| 3 | [Rebase, squash and cherry-pick](exercises/03-rebase-squash-cherry-pick.md) | 5 min |
| 4 | [Oops: reflog, revert and the permanent record](exercises/04-oops-reflog-revert.md) | 5 min |
| 5 | [Bonus: collaboration, and why you never force-push a shared branch](exercises/05-bonus-collaboration-force-push.md) | 5 min |

Check your progress at any time:

```shell
bash "$COURSES/courses/03-git/exercises/check.sh"
```

## Facilitator notes

- **A week before:** send the invite with a link to [Joining a course](../../joining.md)
  (NL: [Meedoen aan een cursus](../../joining.nl.md)).
- **Before:** run `make test`, print the handout and one set of scenario cards per explainer pair.
- **Live demo that works well:** at the end of Part 2, run worksheet 1 steps
  2–4 on the big screen. `cat .git/refs/heads/main` showing one line of text is
  the "aha" moment for many people.
- **Part 4 is the part people need most.** If you're short on time, shorten the
  history in Part 1, not the golden rule.
- **Debrief:** card 1 (the Friday release) or card 2 (the leaked password)
  works well with everyone. Ask the builders what they'd type, and the
  explainers what they'd write to the client.
- Answers and discussion notes are in [solutions/](solutions/tabletop-answers.md).
