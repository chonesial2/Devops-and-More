# Elastic - Limit indices to specific space on Kibana UI

In this guide you will learn how to manage Kibana spaces, limit indices/logs to specific space.

## Kibana Spaces

- Spaces enable you to organize various Dashboards, Visualizations, Searches, and other so-called Saved Objects on your Kibana instance, into distinct “spaces” where different user groups can access what they need.
- This can be especially useful for segregating various business users according to departments like Marketing, Security, Development, Operations, Finance etc.
- You can also assign access to multiple spaces for specific users, in which case they’ll see their accessible spaces when logging in.

> **NOTE**: As you can see right away, there’s already one space created for us by default (named Default). It’s always present if you haven’t explicitly disabled spaces. All objects that are contained inside the default space are shared between all users.


## Create a space in Kibana

- Login with superuser (usually named `elastic` )
- In left side click on menu icon (3 bars) and select `Stack Management`
- Inside `Kibana` section, select `Spaces` option
- To create a new space, click on `Create space` button
  - Add the name like `“DevOps”` and you can optionally provide a description.
  - You have the option to choose a color for space. This is helpful to visually differentiate spaces for users who have access to multiple spaces.
  - Set feature visibility

> **NOTE**: Hidden features are removed from the user interface, but not disabled. To secure access to features, manage security roles.

## Create a Role with specific index pattern and space(s)

Roles are used to manage persmission for a group of users.

- Navigate to `Management` and select `Roles`
- Click on `Create role` button and supply below inputs
  - `Role Name` - like - "Devops"
  - There are two sections, Elasticsearch (to add Elasticsearch privileges) and Kibana (to add Kibana privileges)
  - In Elasticsearch section, select `Index Pattern` and `privileges`
  - In Kibana section, click on `Add Kibana privilege`
    - Select one or more `Space`
    - `Customize feature privileges` - Increase privilege levels on a per feature basis.

> **NOTE**: If you assign this role to any user then the user will have the permission to access specific space with assigned indices.

## Create User and assigned the role

- Navigate to `Management` and select `Users`
- Click on `Create user` button
  - `Profile` - Provide personal details.
  - `Password` - Protect your data with a strong password.
  - `Privileges` - Assign roles to manage access and permissions.











