# Readme

In order to use this ansible repo please ensure you have specified the correct SSH key path from your local system into this inventory file:
`environments/<project-name>/inventory`

## Projects managed

- OpsPi
- Project 2

## Credentials

All credentials and tokens are in ansible vault file at environments/<project-name>/group_vars/all.yml

## Sample playbook commands 

- **App DB**

```bash
ansible-playbook -i environments/opspi-dev/inventory playbooks/opspi-dev/database.yml  --ask-vault-pass
```

**tags**
  - configure


