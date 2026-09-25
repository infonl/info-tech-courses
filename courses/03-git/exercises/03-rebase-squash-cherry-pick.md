🇬🇧 English · 🇳🇱 [Nederlands](03-rebase-squash-cherry-pick.nl.md)

# 🛠 3 · Rebase, squash and cherry-pick

⏱ 5 min · **Goal:** tidy up **your own** branch before sharing it, and copy a
single fix to another branch. Watch the hashes: every rewrite makes **new** commits.

## Step 1: a messy feature branch

```bash
cd ~/lab/03/shop
git switch -q -c feature/newsletter
echo "Sign up for our newsletter" > newsletter.txt
git add newsletter.txt
git commit -q -m "Add newsletter"
echo "Every month" >> newsletter.txt
git commit -q -am "wip"
echo "Unsubscribe any time" >> newsletter.txt
git commit -q -am "fix typo"
git log --oneline -3 | tee ../before-rebase.txt
```

Meanwhile, a colleague adds something to `main`:

```bash
git switch -q main
echo "Closed on Sundays" >> hours.txt
git commit -q -am "Sunday closing"
git log --oneline --graph --all -8
```

## Step 2: rebase, replay my work on top of the new main

```bash
git switch -q feature/newsletter
git rebase main
git log --oneline -3
cat ../before-rebase.txt
git log --oneline --graph --all -8
```

Same messages, same changes, but **different hashes**: rebase made
**copies** on top of the new `main`. The old commits still exist (for now),
nothing points at them any more.

## Step 3: squash, three commits become one

This is what a platform's *"Squash and merge"* button does:

```bash
git switch -q main
git merge --squash feature/newsletter
git commit -q -m "Add newsletter sign-up (#12)"
git log --oneline -3
```

`main` gets **one** tidy commit; the `wip` and `fix typo` commits stay out of the main history.

Interactive alternative on your own branch: `git rebase -i main` opens an editor
where you can squash, reword and reorder commits.

## Step 4: cherry-pick a hotfix onto a release

Version 1.0 (the tag from worksheet 1) is in production. A fix made on `main`
is urgently needed there too, **without** all the other new work from `main`:

```bash
echo "Contact: shop@example.com" > CONTACT.txt
git add CONTACT.txt
git commit -q -m "Hotfix: add contact address"
git switch -q -c release/1.0 v1.0
git cherry-pick main
git log --oneline
ls
```

`release/1.0` now has the hotfix, but not the price list or the newsletter.

## 🤔 Questions

1. After the rebase, why do the commits have new hashes? (Think of worksheet 1:
   what's inside a commit?)
2. Rebasing changed history. Why was that OK here? When would it **not** be OK?
3. The cherry-picked commit on `release/1.0` has a different hash than the
   original on `main`. Why?
4. What do you lose with *squash and merge*? What do you gain?

➡️ Next: [4 · Oops: reflog, revert and the permanent record](04-oops-reflog-revert.md)
