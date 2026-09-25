# Facilitator answers · Builder worksheets (course 03)

## 1 · Under the hood

1. **Yes**: `ce01362…`, on any computer. Git names content by its hash, so
   identical content is stored once and can be verified anywhere. That's how
   clones can check they're complete and untampered.
2. **41 bytes** (40 hex characters and a newline). Creating a branch costs
   nothing, which is why git encourages branch-per-feature.
3. Both point at a commit. When you commit on `feature/prices`, that branch
   **moves** to the new commit. `v1.0` **stays** on the commit it was put on.
   That's what makes a tag a reliable marker for a release.

## 2 · Branches and merges

1. In step 1, `main` had no new commits since the branch was made, so git could
   simply move the `main` label forward (fast-forward). In step 2 both sides
   had new work, so a commit with two parents was needed to join them.
2. Neither was wrong: they were two decisions made in parallel. In real life,
   the people involved (or the product owner) decide. Git can only point out
   that they disagree.
3. Git compares the two snapshots on the fly. Because every snapshot is
   complete, any two can be compared, no matter how far apart.

## 3 · Rebase, squash and cherry-pick

1. A commit contains its parent's hash. After the rebase the parent is the new
   `main` tip, so the content of every commit changes, and with it the hash.
   Rebase makes copies.
2. Nobody else had those commits: the branch was never pushed. Once others have
   pulled a branch, rebasing it pulls the rug from under them. Their commits are
   built on photos that no longer exist on the shared branch.
3. Same reason: a different parent (the `v1.0` commit instead of the `main`
   history), and a different committer time. The change is identical.
4. You lose the individual steps on `main`: the separate commits for "wip"
   and "fix typo". You gain one clean, reviewable, revertable commit per change.
   The pull request on the platform still has the full discussion and history.

## 4 · Oops: reflog, revert and the permanent record

1. **No.** The reflog is local and private. A colleague has their own.
   On the remote, a force-pushed-away commit is only recoverable by whoever
   still has it, or by the platform's support.
2. `revert` adds a commit, so nobody's copy is invalidated, and history shows
   the mistake and the fix. `reset` + force-push rewrites the shared branch
   (see worksheet 5).
3. **Rotate the password first.** Rewriting history comes later, if at all;
   the secret is already out.

## 5 · Bonus: collaboration and force-push

1. Then Bob's work would be gone from everywhere, except maybe in Bob's reflog
   (if his clone still existed), a CI cache, or the platform's own backups.
2. On **your own** branch that only you push to, after you rebased or amended
   it. `--force-with-lease` still refuses if someone else pushed in the meantime.
3. At least `main` and all `release/*` branches: no force-push, no deletion,
   changes only through pull requests with review and passing checks.

**A trap worth knowing:** after someone force-pushed, `git pull --rebase` can
silently **drop** your commits. Git sees they were once on the remote branch,
so it assumes the remote removed them on purpose (the "fork-point" logic).
That's why the repair in step 6 uses a merge (`--no-rebase`). In real life:
if a shared branch was force-pushed, **stop**, compare `git log` of your copy
with the remote, and ask before pulling.
