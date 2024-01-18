# Guide to review MR/PR/DR

1. If there is any variable/value which would be different for different environments, should be kept in environment variables.

    **e.g.:** API_ENDPOINT

1. Any kind of the credentials should not be pushed to repository. This should be kept in environment variables.

    **e.g.:** DB_USER, DB_PASSWORD

1. The original env file (Usually from dev) should not be pushed to repo. It should be added in .gitignore file.

1. For reference to environment vars, we should push a example file .env.example

1. The example file should contain a matching example for values.

    **e.g.** For DB String: <username>:<passowrd>@<host>/<db_name>

