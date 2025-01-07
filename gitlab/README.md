# Gitlab

## Installation

1. Use the teraform configuration at `teraform/files/gitlab_custom_vpc` to create a minimal EC2 instance.

2. Mount the EBS volume where we will store data. Note that Amazon Linux 2 does not install tools like pvcreate by default. Install the `lvm2` package to install lvm tools. The volume should be mounted at `/var/opt`.

3. Run the script at https://packages.gitlab.com/gitlab/gitlab-ce/install#bash-rpm to install the gitlab package repository.
3. Install gitlab; for example: `sudo EXTERNAL_URL="https://<ip.of.your.instance>" dnf install -y gitlab-ce`. This can take a long time.

## Tips
- Gitlab needs a lot of storage to install. The root disk should be be at least 10G.
- After installation, retrieve the root password at /etc/gitlab/initial_root_password.
- Login as root. As a first step, you might want to disable auto signup. 
- If you make any changes to gitlab configuration, run `sudo gitlab-ctl reconfigure`. 
- You can use pwgen to generate passwords

## GitLab Fundamentals
In GitLab, projects can be organized into subgroups to organizer yoru codebase. A subgroup can be nested.

Projects can be assigned an owner. 

## Working with Git
To use git from gitlab, add your public key by clicking your profile | SSH Keys.

You can test the connection by running `ssh -T git@gitlab.com`.

Once you have cloned a git repository, there are two ways to create a branch.

```sh
git branch <branch>
git checkout <branch>

# or

git checkout -b <branch>
```

You can list all branches by running:

```sh
git branch -a
```

This command will show both remote branches (in red) and local branches (in green).

To push changes to a branch, use `git push`. If unsure of the syntax (for example, you have a local branch) run `git push`.

Once you have pushed a local branch to an upstream branch, simply type `git push`.

```sh
git push
```

When you're collaborating with others on a branch, chances are someone has pushed changes to the branch and you are behind. To find out how far behind you are, first retrieve metadta about branches.

```sh
git fetch
```

Next, run `git status`.

```sh
git status
```

For example:

```sh
$ git status
On branch temporary_branch
Your branch is behind 'origin/temporary_branch' by 1 commit, and can be fast-forwarded.
  (use "git pull" to update your local branch)

nothing to commit, working tree clean
```

To merge changes from a branch to the main branch, first checkout the main branch.

```sh
git checkout main
```

Then merge the branch.

```sh
git merge temporary_branch
```

## Using Gitlab to merge code
GitLab supports issues and merge requests. Merge requests basically means merging branches. You can also create an issue and merge branches. 

## Creating build pipelines
To create a build pipeline, create a file called `.gitlab-ci.yml` at the top level of the project. You can do this using the Gitlab UI. 

While creating this file, Gitlab will display a dropdown list with a choice of templates. We can use one of these to create a pipeline that just involves invoking Bash commands (for example). We need to define the stage block with the list of stages we want to invoke.

```yml
stages:
    - build
    - test

build1:
  stage: build
  script:
    - echo "Do your build here"

test1:
  stage: test
  script:
    - echo "Do a test here"
    - echo "For example run a test suite"
```

## Auto DevOps
Auto DevOps is a feature that basically tells GitLab to create the pipeline for us. This is configured per project. 

## SAST
SAST stands for static application security test. To enable SAST, simply add the following to `.gitlab-ci.yml`

```yml
include:
  - template: Jobs/SAST.gitlab-ci.yml
```

## References
- https://about.gitlab.com/install/#amazonlinux-2023

- Automating DevOps with GitLab CI/CD Pipelines
