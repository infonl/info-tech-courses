# Facilitator answers · Scenario cards (course 03)

## Card 1 · The Friday release

1. The force-push moves `main` backwards on the remote. The three colleagues
   still have the "removed" commits. Their next pull gets confusing, and
   their next push may bring the bad commits right back. Any other work pushed
   to `main` today is lost from the shared history. Open pull requests based on
   the old `main` break. The audit trail no longer shows what was live.
2. `git revert <bad commit>` (or revert the merge of the pull request), open a
   small pull request, deploy. History shows: feature → revert. Nobody's copy
   breaks. Later the feature comes back with a fix (fix forward).
3. *"The release had a bug. We reverted the change at 17:05 and redeployed;
   here's the pull request with the revert and the timeline."* Git and the
   platform show exactly what went live when, as long as history wasn't rewritten.

## Card 2 · The leaked password

1. **No.** It's in the older commit, so in every clone, fork, CI cache and
   backup. On a public repository, bots find credentials within minutes.
2. **Rotate the password** (change it on the database, update the application)
   immediately. That's the database owner's or operations' job, not the
   developer's clean-up. Check the logs for misuse. Only then consider
   rewriting history with `git filter-repo`, coordinated with everyone who has
   a clone. It reduces exposure, but it doesn't undo it.
3. `.gitignore` for `.env`, keys and `.pfx`, secret scanning with push
   protection on the platform, a secrets manager or CI variables instead of
   config files, and a blameless "what to do if" in the team's working
   agreements, so people report quickly instead of hiding it.

## Card 3 · The hotfix during a big feature

1. Create `release/2.3` (or `hotfix/2.3.1`) from the **tag** `v2.3`, fix it
   there (or fix on `main` and **cherry-pick** the fix), release 2.3.1 from that
   branch.
2. Make sure the fix also lands on `main`: merge the release branch back, or
   cherry-pick in the other direction. Check it in review.
3. Tag every release, so there's always an exact starting point. Feature flags,
   so unfinished work can sit on `main` without being active. Or release
   branches, if the product has several supported versions.

## Card 4 · Squash or not?

1. **Merge commit:** complete history and the real order of work, but a busy
   graph, and every *"wip"* commit stays forever. **Squash:** one commit per pull
   request, easy to read and revert; the step-by-step detail stays in the pull
   request on the platform.
2. **Squash and merge** with the ticket number in the pull request title, which
   becomes the commit message: every commit on `main` = one reviewed change =
   one ticket. (Merge commits with ticket numbers also work; pick one.)
3. Merge method, pull request title format with ticket number, required
   reviewers, required checks, branch protection (no force-push, no direct
   commits to `main`).

## Card 5 · The three-month branch

1. `main` kept changing while the branch didn't take in those changes, and
   nobody integrated the work in small steps. The longer you wait, the worse
   the conflicts: they compound.
2. Merge (or rebase) `main` into the branch in steps, with help from the people
   who made the conflicting changes. Or split the feature into smaller pull
   requests, starting with the least conflicting parts. Sometimes it's cheaper
   to start over on a fresh branch and port the work in pieces.
3. Small pull requests, merged at least weekly. Feature flags for unfinished
   work. Merge `main` into long-running branches regularly. Talk to the people
   working on the same code.

## Card 6 · "Who changed this, and why?"

1. `git log` / `git blame` on the file → the commit (author, date, message) →
   the pull request on the platform (reviewers, approvals, discussion, CI
   results) → the linked ticket (the why and who asked for it).
2. Easy: meaningful commit messages, ticket numbers, required reviews, protected
   `main`. Impossible: direct pushes to `main`, *"fix"* as a commit message,
   squashing without ticket references, rewriting history.
3. The history before April may have been replaced: commits could be missing or
   changed, and approvals may no longer match the code. You'd have to reconstruct
   from backups, clones or platform logs. That's why `main` should be protected.

## Card 7 · Choosing a branching strategy

1. **A:** trunk-based or GitHub flow: short-lived branches, pull requests,
   deploy from `main`, feature flags. **B:** release branches per supported
   version (`release/3.x`, `release/4.x`), tags for every release; GitFlow is
   possible but often heavier than needed.
2. Fix on `main` (or the oldest affected release), then **cherry-pick** to each
   supported release branch, release a patch version from each, and tag them.
3. Both: protected `main` (and release branches), no force-push, required pull
   requests with review and passing checks, secret scanning.

## Common questions

- **"Is git the same as GitHub?"** No. Git is the tool on your computer.
  GitHub, GitLab and Azure DevOps host shared copies and add pull requests,
  reviews, CI and permissions.
- **"Can git handle big binary files?"** Poorly: every version is kept forever.
  Use Git LFS or keep large files elsewhere.
- **"Is SHA-1 still safe?"** Git uses a hardened SHA-1 that detects the known
  collision attacks, and supports SHA-256 repositories. For everyday use it's fine.
