🇬🇧 English · 🇳🇱 [Nederlands](04-oops-reflog-revert.nl.md)

# 🛠 4 · Oops: reflog, revert and the permanent record

⏱ 5 min · **Goal:** rescue "lost" work with the reflog, undo a mistake the
safe way, and find out why a deleted password isn't gone.

## Step 1: a scary mistake

```bash
cd ~/lab/03/shop
git switch -q main
git log --oneline -4
git reset -q --hard HEAD~2
git log --oneline -4
```

The newsletter and the hotfix are gone from `main`. Or are they?

## Step 2: the reflog remembers

The **reflog** is git's diary: every place `HEAD` has been, on **your**
computer, for about 90 days.

```bash
git reflog -5
git reset -q --hard 'HEAD@{1}'
git log --oneline -4
```

`HEAD@{1}` means *"where HEAD was one step ago"*. Everything is back.

> 💡 The reflog only protects work that was **committed**. Uncommitted changes
> thrown away with `reset --hard` are really gone.

## Step 3: fix forward with revert

A wrong price reaches `main`, and others may already have pulled it. Don't
rewrite history. Add a new commit that **undoes** the bad one:

```bash
echo "Apples: FREE" > prices.txt
git commit -q -am "Update prices"
git revert --no-edit HEAD
cat prices.txt
git log --oneline -3
```

History now tells the true story: the mistake **and** the fix. Nobody who
pulled in between gets into trouble.

## Step 4: the permanent record

Someone commits a password, and removes it in the next commit:

```bash
echo "DB_PASSWORD=hunter2" > config.env
git add config.env
git commit -q -m "Add config"
git rm -q config.env
git commit -q -m "Remove config"
ls
git log --oneline -S hunter2
git show HEAD~1:config.env
```

The file is gone from the latest snapshot, but **every older snapshot still
has it**. Anyone who cloned the repository has the password.

## Step 5 (optional): rescue a deleted branch

When you delete a branch, git tells you where it pointed. Try it yourself:

```shell
git branch -D feature/opening-hours      # prints: Deleted branch … (was 1a2b3c4).
git branch feature/opening-hours 1a2b3c4  # use the hash git printed
```

## 🤔 Questions

1. The reflog saved you in step 2. Would it save a colleague on **their** computer?
2. Why is `revert` better than `reset` + force-push on a shared branch?
3. The password was pushed to a shared repository. What must happen **first**:
   cleaning up history, or something else?

➡️ Bonus: [5 · Collaboration and force-push](05-bonus-collaboration-force-push.md)
