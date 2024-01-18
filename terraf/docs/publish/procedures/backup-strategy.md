# Backup Strategy Generic
Server = Droplet/Instance

## Backup and retention rules

- If the server is hosting the database
  - Daily backup should be scheduled
  - Retention period should be minimum 7 days
- Stateless Servers
  - No daily backup is required
  - Make sure to Enable backup option in Digital Ocean
- Stateful Servers
  - Daily backups are needed
  - Make sure to Enable backup option in Digital Ocean

## Definations

- Stateless Servers
  - If the server is hosting application with no mounted directory for upload or user files
  - If the server can be recreated without any data loss
  - If deleting the server will not occur data loss
- Stateful Servers
  - If the server contain user files.
  - User files are added when application is running.
  - If deleting the server will occur the data loss.
