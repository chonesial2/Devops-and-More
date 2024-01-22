# How to Contribute to Git Repository

> {sub-ref}`today` | {sub-ref}`wordcount-minutes` min read

## Overview

This workflow is created by following the strategy when 'Master branch is always production deployable'

So the master branch has always the changes ready for production.

## Get code on dev machine and do basic configurations

- Clone the repository to dev machine

```bash
git clone <repo_address>
```

- Set your name globally for git

```bash
git config --global user.name '<your name>'
```

- Set you email globally for git

```bash
git config --global user.email '<your email>'
```

## Start working on a new feature

- Checkout to master branch

```bash
git checkout master
```

- Update code from master

```bash
git pull origin master
```

- Create a new branch from master (Make the branch name relevant to feature and fix we are working)

```bash
git checkout -b <new_feature_branch_name>
```

- Make local changes, Modify the files which you want to. Test code on dev machine (Do your coding and all)

- Add files to git, after the files have been tested well on dev machine

```bash
git add <file1> <file2> <file3> ...
```

- Commit changes to local

```bash
git commit -m '<commit message>'
```

- Update master branch of the repo with latest remote changes

```bash
git checkout master

git pull origin master
```

- Switch back to working branch

```bash
git checkout <new_feature_branch_name>
```

- Rebase with master and resolve conflict if any

```bash
git rebase master
```

- Push changes to new branch on remote

```bash
git push origin <new_feature_branch_name>
```


## Create a Pull request

- Go to git repository on your browser

- Create a new pull request to desired branch (uat or master)

- Verify the new changes from PR

- Merge the changes with master


## Rebase and resolve conflict

- Check if you have any modified files which are not committed

```bash
git status
```

- If there are any modified files then commit them first

- Initiate the rebase process (from master branch)

```bash
git rebase master
```

- Check if there are any conflicts

```bash
git status
```

- If there are any conflicts then follow these steps

- Open conflicted files  and resolve code conflicts in each conflicted file

- Add the resolved conflicted files to git

```bash
git add <file1> <file2> …
```

- Now resume the rebase process

```bash
git rebase --continue
```

- Check if there is conflict in any other files 

```bash
git status
```

- If there is still conflicts in file go to step 4.5 again

- Rebase is done.


