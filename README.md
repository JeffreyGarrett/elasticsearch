# intro
You improve upon your previous ES module by adding multi-node handling, auto-scaling, SGs etc...

You will need to build an indexing pipeline (in Node.js) - a simple script that indexes random data (or one of these -> https://github.com/awesomedata/awesome-public-datasets).

The ES cluster should be easily monitored and alerting should be possible.

Everything should be documented thoroughly.

Bonuses:
  - Easy way to display the data
  - Any other bonuses are welcome!

# whats included
  - Typescript/node.js cli application for working with elasticsearch data indexing
    - see `./consoleApp/elastic/README.md for more information here
  - extendable elasticsearch infrastructure code using Terraform
    - elastichsearch service 
    - cognito setup (user and identity pool) to be used with elasticsearch
      - access to kibana dashboard through provided identity
      (removed restriction on access to domain in order to make cli tool easy to implement)
    - cloudwatch dashboard (preset by service)
      - included code for basic monitor
    

# what's not included
  - VPC: vpc limits monitoring capabilities
  - SG's: see above
  - auto scaling: scaling is more complicated with elasticsearch.  see here https://stackoverflow.com/questions/18010752/how-to-setup-elasticsearch-cluster-with-auto-scaling-on-amazon-ec2  although think it's possible if you setup enough shards and scale according to the shard. 

# dependencies infrastructure
- terraform
- aws account and credentials

# folder structure
```
|-- consoleApp    (location of cli resources)
|
├── deployment    (where your deploying infrastructure) 
│   ├── local     (best to keep a local one for deploying test clusters)
│   └── prod
└── modules        (all modules here)
    └── provider         (align by provider)
            └── services  (followed by the services in the folder)
```

*services should contain everything needed for that service in the folder.  parameterizing resources such as storage for reuse would be redundant.  But services (or microservices) is a good level*

# Access kibana
due to a loop, you'll have to manually configure a couple things until the loop is fixed. 
- create user in cognito `es_user_pool` and assign to `group es_user_group`
- go to `es_user_pool_client` and enable cognito user pool and set the callback urls to the es kibana urls appended with `/app/kibana`. 
- manually setup the config for authorized providers in es_idendity_pool.  The automated generated app with es works. 
- create a new role and policy through gui for authenticated identities in es_identity_pool
  - update the policy to allow for access to es
  (not policy needs updating in trust linking for es_cognito_group)


# TODO's