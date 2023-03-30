# Merging Branches

Suppose we have a git repo at https://github.com/tarof429/cursor.

We make a branch called `test`, make some changes, and commit them to the branch.

```
taro@zaxman cursor]$ git checkout -b test
Switched to a new branch 'test'
$ code .
$ git status
On branch test
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
$ git add .
$ git commit -m "Add a comment"
[test affd8ab] Add a comment
 1 file changed, 2 insertions(+)
```

Now let's go back to main, make some changes, and commit them to the branch.

```
$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
$ git add .
$ git commit -m "Add a comment"
[main 287c192] Add a comment
 1 file changed, 2 insertions(+)
$ git branch
* main
  test
```

To merge the `test` branch into `main`, We use the `git merge <branch-to-merge>`.  An editor popwill pop up, giving us a chance to customize the comment. In this case, the merging was done for us. 

```
taro@zaxman cursor]$ git merge test
Auto-merging README.md
Merge made by the 'ort' strategy.
 README.md | 2 ++
 1 file changed, 2 insertions(+)
```

Although this time the merge succeeded, sometimese merges can fail.

```
$ git merge test
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
```

If we open the codebase with VisualStudio Code, we can see where the merge failed.

```
<<<<<<< HEAD
Foo bar!
=======
>>>>>>> test
I am a test.
```

Once you resolve this issue, you should be able to commit the merge.

```
$ git commit -m "Fix merge issue"
[main b46301f] Fix merge issue
```

## References

https://www.freecodecamp.org/news/how-to-fix-merge-conflicts-in-git/