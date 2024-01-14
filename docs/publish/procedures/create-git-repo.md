# How to create and configure a git repo

- Make sure to create repo under proper groups/organisation

## Gitlab

1. Create a git repo.
1. Create at least 2 branches:
    1. main/master
    1. dev
1. Configure default branch to **dev**:
    1. Settings -> Repository -> Default branch
1. Protect the branches (main/master and dev):
    1. Settings -> Repository -> Protected branches
        1. **Branch:** <branch_name>
        1. **Allowed to merge:** Maintainers
        1. **Allowed to push:** Maintainers
        1. **Allowed to force push:** Disabled


