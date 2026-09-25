🇬🇧 English · 🇳🇱 [Nederlands](cheatsheet.nl.md)

# Cheat sheet · 03 Git

## Start and look around

```shell
git init -b main                 # new repository
git clone <url>                  # copy an existing one, with full history
git status                       # what's changed, what's staged
git log --oneline --graph --all  # the album, all branches
git show <hash>                  # one commit: message and changes
git diff                         # unstaged changes
git diff main feature/x          # between any two points
git blame file.txt               # who last changed each line, in which commit
```

## Take a photo

```shell
git add file.txt                 # put a change in the next photo
git commit -m "Say why, not only what"
git commit --amend               # redo the last commit (only if not pushed yet!)
```

## Branches, tags and merging

```shell
git switch -c feature/x          # new branch, and switch to it
git switch main
git merge feature/x              # fast-forward or merge commit
git merge --abort                # back out of a conflicted merge
git branch -d feature/x          # delete a merged branch
git tag -a v1.0 -m "Release 1.0" # an annotated tag
```

## Rewriting your own history (not shared yet!)

```shell
git rebase main                  # replay my branch on top of main
git rebase -i main               # squash, reword, reorder my commits
git merge --squash feature/x     # all of a branch as one change
git cherry-pick <hash>           # copy one commit to this branch
git push --force-with-lease      # only on your own branch, after a rebase
```

## Working with a remote

```shell
git fetch                        # get the others' photos, change nothing locally
git pull --rebase                # fetch, then replay my new commits on top
git push                         # share my commits
git push -u origin feature/x     # push a new branch and track it
```

## Undo and rescue

```shell
git revert <hash>                # new commit that undoes an old one: safe on shared branches
git restore file.txt             # throw away uncommitted changes in a file
git reset --soft HEAD~1          # undo the last commit, keep the changes
git reflog                       # where HEAD has been: the safety net
git reset --hard 'HEAD@{1}'      # go back to where you were one step ago
git branch <name> <hash>         # recreate a deleted branch
```

## Look inside (worksheet 1)

```shell
git cat-file -p HEAD             # the commit object
git cat-file -p 'HEAD^{tree}'    # the folder snapshot
git hash-object file.txt         # the fingerprint git would give this file
cat .git/HEAD .git/refs/heads/main
```
