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

## Sample run project01

```bash
ansible-playbook -i environments/project01/inventory playbooks/project01/api-servers.yml
```
# Install mysql

```bash
ansible-playbook -i environments/mysql-psql-mongodb/inventory playbooks/mysql/install-mysql.yml
```
# Install psql

```bash
ansible-playbook -i environments/mysql-psql-mongodb/inventory playbooks/postgresql/install-psql.yml
```

# Install mongodb

```bash
ansible-playbook -i environments/mysql-psql-mongodb/inventory playbooks/mongodb/install-mongodb.yml
```
