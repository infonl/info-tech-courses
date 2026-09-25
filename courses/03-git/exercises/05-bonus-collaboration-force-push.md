🇬🇧 English · 🇳🇱 [Nederlands](05-bonus-collaboration-force-push.nl.md)

# 🛠 5 · Bonus: collaboration, and why you never force-push a shared branch

⏱ 5 min · **Goal:** simulate a team with a shared repository, see why git
refuses some pushes, and what `--force` really does.

## Step 1: a shared repository and two colleagues

`origin.git` plays the role of GitHub or GitLab. Alice and Bob each clone it.

```bash
cd ~/lab/03
git init -q --bare -b main origin.git
git clone -q origin.git alice 2>/dev/null
git clone -q origin.git bob 2>/dev/null
git -C alice config user.name "Alice" && git -C alice config user.email "alice@example.com"
git -C bob config user.name "Bob" && git -C bob config user.email "bob@example.com"
```

## Step 2: Alice starts, Bob adds

```bash
cd ~/lab/03/alice
echo "# Team shop" > README.md
git add README.md && git commit -q -m "Start"
git push -q origin main
cd ~/lab/03/bob
git pull -q origin main
echo "Bob's idea" > bob.txt
git add bob.txt && git commit -q -m "Bob's idea"
git push -q origin main
```

## Step 3: Alice pushes without pulling first

```bash
cd ~/lab/03/alice
echo "Alice's idea" > alice.txt
git add alice.txt && git commit -q -m "Alice's idea"
git push origin main
```

```text
 ! [rejected]        main -> main (fetch first)
```

Git protects Bob's work: Alice's push would throw his commit away.

## Step 4: the safety catch, `--force-with-lease`

```bash
git push --force-with-lease origin main
```

```text
 ! [rejected]        main -> main (stale info)
```

*"Force, but only if the remote is still where I last saw it."* It isn't:
Bob pushed in the meantime. Refused again. Good.

## Step 5: what `--force` does 💥

```bash
git push --force origin main
git clone -q ~/lab/03/origin.git ~/lab/03/carol
git -C ~/lab/03/carol log --oneline
```

Carol, a new colleague, clones the shared repository: **Bob's commit is gone**.
Anyone who pulls now gets Alice's version of history.

## Step 6: the repair, and the right way

Luckily Bob still has his commit locally. He merges the rewritten remote into
his copy, so both ideas are in it, and pushes that:

```bash
cd ~/lab/03/bob
git log --oneline
git pull -q --no-rebase --no-edit origin main
git push -q origin main
git -C ~/lab/03/carol pull -q origin main
git -C ~/lab/03/carol log --oneline
```

What Alice should have done in step 3: `git pull --rebase origin main`, then `git push`.

## 🤔 Questions

1. What if Bob had deleted his local copy before noticing?
2. When **is** `--force-with-lease` fine? (Hint: whose branch is it?)
3. Which branches should be **protected** on the platform, so nobody can force-push them?

🎉 Done! Run the self-check:

```shell
bash "$COURSES/courses/03-git/exercises/check.sh"
```
