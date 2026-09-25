🇬🇧 English · 🇳🇱 [Nederlands](02-branches-and-merges.nl.md)

# 🛠 2 · Branches and merges

⏱ 5 min · **Goal:** make branches, merge them in the two ways git can, and
resolve a conflict.

## Step 1: a fast-forward merge

Work on a branch while `main` doesn't move:

```bash
cd ~/lab/03/shop
git switch -q feature/prices
echo "Apples: 1 euro" > prices.txt
git add prices.txt
git commit -q -m "Add price list"
git switch -q main
git merge feature/prices
git log --oneline --graph --all
```

`Fast-forward`: nothing new happened on `main`, so git just **moved the
sticky note** `main` forward. No new commit needed.

## Step 2: a real merge

This time `main` also moves on while the branch is open:

```bash
git switch -q -c feature/opening-hours
echo "Open 9-17" > hours.txt
git add hours.txt
git commit -q -m "Add opening hours"
git switch -q main
echo "Welcome to the shop" >> README.md
git commit -q -am "Welcome text"
git merge --no-edit feature/opening-hours
git log --oneline --graph --all
git cat-file -p HEAD | head -4
```

The merge commit has **two parents**: it ties both lines of work together.

## Step 3: what changed? Diffs

Git stores snapshots, and **computes** differences when you ask:

```bash
git diff HEAD~2 HEAD
git show --stat HEAD~1
```

## Step 4: a conflict

Two branches change **the same line**. Git can't decide who's right, so it asks you.

```bash
git switch -q -c feature/cheaper
sed -i 's/1 euro/80 cents/' prices.txt
git commit -q -am "Cheaper apples"
git switch -q main
sed -i 's/1 euro/1.20 euro/' prices.txt
git commit -q -am "Pricier apples"
git merge feature/cheaper
cat prices.txt
```

```text
<<<<<<< HEAD
Apples: 1.20 euro
=======
Apples: 80 cents
>>>>>>> feature/cheaper
```

The team decides: the price stays 1 euro. Write the decision, then finish the merge:

```bash
echo "Apples: 1 euro" > prices.txt
git add prices.txt
git commit -q --no-edit
git log --oneline --graph -6
```

## 🤔 Questions

1. Why didn't step 1 create a merge commit, while step 2 did?
2. In the conflict, was either version "wrong"? Who should decide in real life?
3. `git diff` works between **any** two commits. How can it, if git stores snapshots instead of changes?

➡️ Next: [3 · Rewriting your own history](03-rebase-squash-cherry-pick.md)
