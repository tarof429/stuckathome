# Deleting Branches in Git

## Deleting Local Branches

Suppose we have a git repository at git@github.com:tarof429/cursor.git and we've just created a local branch called test.

```
$ git clone git@github.com:tarof429/cursor.git
$ cd cursor
$ git checkout -b test
Switched to a new branch 'test'
$ git branch   
  main
* test
```

The command to delete a local branch is `git branch -d <branch>. If we try to delete a branch that is currently check out, you will get an error:

```
$ git branch -d test
error: Cannot delete branch 'test' checked out at '/home/taro/Code/cursor'
```

The solution is to checkout a different branch like `main` and perform the deletion.

```
$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
$ git branch -d test
Deleted branch test (was 10453b9).
```

## Deleting Remote Branches

Now suppose we've pushed a local branch to remote.

```
git checkout -b test
Switched to a new branch 'test'
$ git remote -v
origin	git@github.com:tarof429/cursor.git (fetch)
origin	git@github.com:tarof429/cursor.git (push)
$ git push origin test
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote: 
remote: Create a pull request for 'test' on GitHub by visiting:
remote:      https://github.com/tarof429/cursor/pull/new/test
remote: 
To github.com:tarof429/cursor.git
 * [new branch]      test -> test
$ git branch -a
  main
* test
  remotes/origin/HEAD -> origin/main
  remotes/origin/main
  remotes/origin/test
```

To delete the local branch, we first switch to the main branch like before.

```
$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
$ git branch -d test
Deleted branch test (was 10453b9).
```

Afterwards, we can delete the remote branch.

```
$ git push origin -d test
To github.com:tarof429/cursor.git
 - [deleted]         test
$ 
$ git branch -a
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/main
$ 
```

Where `-d` is short for `--delete`. 

That's it.

## References

https://www.freecodecamp.org/news/git-delete-remote-branch/

