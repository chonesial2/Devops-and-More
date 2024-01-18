# Elastic - Setup logs with standard format using API


Steps to follow
---

Lets say the project name is `Cyborg` and app name is `droids`

- Create Kibana Space - `0x123-Cyborg`

Kibana API - Example

```sh

$ curl -X POST <kibana host>:<port>/api/spaces/space

{
  "id": "0x123-Cyborg",
  "name": "0x123-Cyborg",
  "description" : "This is the Cyborg Space",
  "color": "#aabbcc",
  "initials": "CY",
  "disabledFeatures": [],
  "imageUrl": "data:image/png;base64,iVBFe...........AABJRU5ErkJggg=="
}

```

> More info - https://www.elastic.co/guide/en/kibana/current/spaces-api-post.html

- Create Index pattern on Kibana - `0x123-Cyborg-*`

API Example - default space

```sh

$ curl -X POST <kibana host>:<port>/api/index_patterns/index_pattern

{
  "index_pattern": {
     "title": "0x123-Cyborg-*"
  }
}
```

API Example - custom space `0x123-Cyborg`

```sh

$ curl -X POST <kibana host>:<port>/s/<space_id>/api/index_patterns/index_pattern

{
  "index_pattern": {
     "title": "0x123-Cyborg-*"
  }
}
```

> More info. - https://www.elastic.co/guide/en/kibana/current/index-patterns-api-create.html

- Create Kibana Role - `0x123-Cyborg`

API Example - Grant access to various features in `0x123-Cyborg` space and assign index pattern `0x123-Cyborg-*`



```sh
$ curl -X PUT <kibana host>:<port>/api/security/role/my_kibana_role

{
  "metadata" : {
    "version" : 1
  },
  "elasticsearch": {
    "cluster" : [ ],
    "indices" : [ "0x123-Cyborg-*"]
  },
  "kibana": [
    {
      "base": [],
      "feature": {
       "discover": [
          "all"
        ],
        "visualize": [
          "all"
        ],
        "dashboard": [
          "all"
        ],
        "dev_tools": [
          "read"
        ],
        "advancedSettings": [
          "read"
        ],
        "indexPatterns": [
          "read"
        ],
        "graph": [
          "all"
        ],
        "apm": [
          "read"
        ],
        "maps": [
          "read"
        ],
        "canvas": [
          "read"
        ],
        "infrastructure": [
          "all"
        ],
        "logs": [
          "all"
        ],
        "uptime": [
          "all"
        ]
      },
      "spaces": [
        "0x123-Cyborg"
      ]
    }
  ]
}

```

> More Info - https://www.elastic.co/guide/en/kibana/current/role-management-api-put.html

- Create Kibana User - `0x123-Cyborg` and assign role - `0x123-Cyborg`

API Example

```sh
curl -X POST <kibana host>:<port>/internal/security/users/<user-name>

{
"password":"**********",
"username":"user-name",
"full_name":"full-name",
"email":"",
"roles":["0x123-Cyborg"]
}
```


