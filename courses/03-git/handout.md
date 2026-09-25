🇬🇧 English · 🇳🇱 [Nederlands](handout.nl.md)

# Git on one page

*Handout for course 03 · Git*

## The picture to remember

Git is a **photo album** of your project. Every **commit** is a snapshot of all
files, named by its **fingerprint** (hash), and it points to the photo before it.
**Branches** and **tags** are sticky notes on photos; **HEAD** is *"you are here"*.

> **The golden rule:** never rewrite history that someone else may already have.

## Safe, careful, never

| | Commands | Why |
|---|---|---|
| 🟢 **Always safe** | `commit`, `branch`, `switch`, `merge`, `revert`, `fetch`, `pull`, `push`, `log`, `diff`, `tag` | They only **add** photos or move **your** labels forward |
| 🟡 **Only on your own, unshared branch** | `rebase`, `commit --amend`, squash, `reset`, `push --force-with-lease` | They make **new copies** and throw the old ones away. Fine if nobody else has the old ones |
| 🔴 **Never on a shared branch** (`main`, `release/*`, a colleague's branch) | `push --force`, `reset` of pushed commits, rewriting history with `filter-repo` without the whole team | Colleagues' work disappears, their copies break, the audit trail is gone |

## Merging a pull request: pick one per team

| Button | `main` gets | Choose when |
|---|---|---|
| **Merge commit** | all commits + a merge commit | you want the complete, true history |
| **Squash and merge** | one commit per pull request | you want a tidy history, one commit per change, easy to revert |
| **Rebase and merge** | the commits, in a straight line | every commit is meaningful on its own |

## Branching strategies

| Strategy | In short | Fits |
|---|---|---|
| **Trunk-based** | tiny branches, merged daily; unfinished work behind feature flags | continuous deployment, strong CI |
| **GitHub flow** | short-lived branch → pull request → `main` → deploy | most web apps and SaaS |
| **Release branches** | `release/1.x` per supported version; fixes are cherry-picked | products with several supported versions |
| **GitFlow** | `develop`, `feature/*`, `release/*`, `hotfix/*` | versioned releases, large teams. Often heavier than needed |

**Rule of thumb:** short-lived branches, merged often.

## First aid

| Oops | Rescue |
|---|---|
| "I reset and my commits are gone" | `git reflog`, then `git reset --hard HEAD@{1}` (or the hash you need) |
| "I deleted a branch" | Git printed `(was 1a2b3c4)`: `git branch <name> 1a2b3c4`. Or find it in `git reflog` |
| "A bad commit is on `main`" | `git revert <hash>` → a new commit that undoes it. **Fix forward**, don't erase |
| "Merge conflict!" | Open the file, choose between `<<<<<<<` and `>>>>>>>`, remove the markers, `git add`, `git commit`. Or `git merge --abort` |
| "My push is rejected" | Someone pushed first: `git pull --rebase`, then `git push`. **Not** `--force` |
| "I committed to the wrong branch" | `git switch -c right-branch` (takes the commit along), then fix the old branch. Ask for help if it was already pushed |

The reflog only exists on **your** computer and keeps about 90 days of
**committed** work. Uncommitted changes are not protected: commit early and often.

## A secret was committed

1. **Revoke and rotate** the secret **now**. Assume it's leaked: everyone who
   cloned has it, and bots scan public repositories within minutes
2. Tell the owner of the system it belongs to
3. **Then** remove it from the code, and decide with the team whether to rewrite
   history (`git filter-repo`). That's clean-up, not the fix
4. **Prevent:** `.gitignore` for `.env` and keys, secret scanning on the platform, a secrets manager

## A good commit message

```text
Show opening hours on the contact page        ← what, in max ~50 characters

Customers kept calling to ask when we're open. ← why
Hours come from the same config as the footer.
Refs: SHOP-142                                 ← ticket
```
