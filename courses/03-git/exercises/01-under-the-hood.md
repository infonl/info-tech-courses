🇬🇧 English · 🇳🇱 [Nederlands](01-under-the-hood.nl.md)

# 🛠 1 · Under the hood: photos and sticky notes

⏱ 4 min · **Goal:** see that a commit is a snapshot named by its fingerprint,
and that branches and tags are just labels pointing at one.

## Step 1: a new repository

```bash
mkdir -p ~/lab/03 && cd ~/lab/03
git init -q -b main shop && cd shop
git config user.name "Alice" && git config user.email "alice@example.com"
echo "hello" > README.md
git add README.md
git commit -q -m "Add README"
git log --oneline
```

## Step 2: everything is named by its fingerprint

Git names every piece of content by its hash, like the fingerprints in course 01.
The same content gets the same name, on every computer in the world:

```bash
git hash-object README.md
```

```text
ce013625030ba8dba906f756967f9e9ca394464a
```

Now look inside the commit, then inside the folder snapshot (the *tree*) it
points to, and finally the file content (the *blob*):

```bash
git cat-file -p HEAD
git cat-file -p 'HEAD^{tree}'
git cat-file -p ce01362
```

The commit is a small text: *which tree*, *who*, *when*, *why*. From the
second commit on, it also says *which parent*.

## Step 3: a second photo

```bash
echo "We sell apples" >> README.md
git commit -q -am "Say what we sell"
git cat-file -p HEAD
```

Note the `parent` line: every commit points to the one before it. Change
anything in an old commit, and its hash changes, and so does every hash after
it. That's what makes history tamper-evident.

## Step 4: branches and tags are sticky notes

```bash
cat .git/HEAD
cat .git/refs/heads/main
git branch feature/prices
git tag v1.0 HEAD~1
cat .git/refs/heads/feature/prices .git/refs/tags/v1.0
git log --oneline --decorate --all
```

A branch is a tiny file with one commit hash in it: a sticky note on a
photo. `HEAD` is the *"you are here"* arrow, pointing at the branch you're on.

## 🤔 Questions

1. Your colleague runs `git hash-object` on a file with exactly `hello` in it.
   Will they get the same hash? Why does that matter?
2. How big is a branch, in bytes? What does that say about the cost of creating one?
3. What's the difference between the branch `feature/prices` and the tag `v1.0`?
   (Hint: what happens to each when you make a new commit?)

➡️ Next: [2 · Branches and merges](02-branches-and-merges.md)
