# intro
Search and monitor.

You will have to create a Terraform module that deploys (preferably on AWS) and manages an ElasticSearch (ES) cluster.

The ES cluster should be easily monitored and alerting should be possible.

Everything should be documented thoroughly.

Bonuses:
  - Easy way to display the data
  - Any other bonuses are welcome!

# dependencies
- terraform
- aws credentials

# folder structure
|-- deployment
    |--local
    |--prod
|-- modules
    |-- provider
        |-- services

|--deployment    (where your deploying infrastructure)

    |── local     (best to keep a local one for deploying test clusters)

    |── prod

|── modules        (all modules here)
    |── provider         (align by provider)
        |── services  (followed by the services in the folder)

*services should contain everything needed for that service in the folder.  parameterizing resources such as storage for reuse would be redundant.  But services (or microservices) is a good level*