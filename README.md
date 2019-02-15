# intro
Se

#dependencies


#folder structure
├── deployment    (where your deploying infrastructure)
│   ├── local     (best to keep a local one for deploying test clusters)
│   └── prod
└── modules        (all modules here)
    └── provider         (align by provider)
        └── services  (followed by the services in the folder)

*services should contain everything needed for that service in the folder.  parameterizing resources such as storage for reuse would be redundant.  But services (or microservices) is a good level*