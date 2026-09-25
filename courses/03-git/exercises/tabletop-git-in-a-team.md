🇬🇧 English · 🇳🇱 [Nederlands](tabletop-git-in-a-team.nl.md)

# 🗣 Scenario cards: git in a team

⏱ 15 min · **In pairs.** No terminal needed; keep the [handout](../handout.md) next to you.

**How it works:** pick 3–4 cards. For each card, answer: **what's going on**,
**what should happen now**, and **what should the team agree on** so it
doesn't happen again. Be ready to present one card in the debrief.

**The rule you need most:** *never rewrite history that someone else may already have.*

---

## Card 1 · The Friday release

Friday 16:30. The release that went live an hour ago contains a bug. A developer
proposes: *"I'll reset `main` to yesterday and force-push, then redeploy."*
Three colleagues have pulled `main` since this morning.

1. What goes wrong with the proposal, and for whom?
2. What's the safer alternative? What does the history look like afterwards?
3. What would you tell the client about what happened, and how can you show it?

---

## Card 2 · The leaked password

A developer committed the production database password to the repository and
pushed it. Ten minutes later they removed it in a new commit: *"Fixed, it's gone."*

1. Is it gone? Why (not)?
2. What must happen **first**, and who has to do it?
3. What would you put in place so this doesn't happen again?

---

## Card 3 · The hotfix during a big feature

Version 2.3 runs in production. `main` already contains half-finished work for
2.4. A critical bug is found in production.

1. How do you get a fix into production **without** the unfinished 2.4 work?
2. How do you make sure the fix doesn't get lost for 2.4?
3. What would have made this easier? (Hint: branching strategy, feature flags.)

---

## Card 4 · Squash or not?

The team argues about the *"merge"* button. One developer wants every commit
kept; another wants one commit per pull request. The client requires that every
change on `main` can be traced to a ticket.

1. What are the pros and cons of **merge commit** vs **squash and merge**?
2. Which would you choose here, and why?
3. What would you write down in the team's working agreements?

---

## Card 5 · The three-month branch

A feature branch has been open for three months. Merging it into `main` gives
hundreds of conflicts. The developer asks for a week to *"sort out the merge"*.

1. How did it get this bad?
2. What are the options now?
3. What would you advise for the next big feature?

---

## Card 6 · "Who changed this, and why?"

An auditor asks: *"Who changed the discount calculation in March, who approved
it, and why?"*

1. Where in git and on the platform would you find the answers?
2. Which team habits make this question easy, and which make it impossible?
3. Someone force-pushed `main` in April. What does that mean for the audit?

---

## Card 7 · Choosing a branching strategy (bonus)

Two new projects start:
**A**: a web shop that deploys to production several times a day.
**B**: a product installed at 40 customers, where each customer can stay on an
older version for up to two years under a support contract.

1. Which branching strategy fits each project? Why?
2. How does a bug fix reach all supported versions in project B?
3. What should the platform enforce in both projects?
