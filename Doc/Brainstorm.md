# Brainstorming 

- what should we focus?
    1. ***Initial Deployment :*** This can be developed much quicker.
    1. ***Updating alerts through configuration:*** In this case we will need to consider a workflow and what to do what not to do.
        - adding new alerts
        - remove new alerts
        - change settings

# Options
1. Enable metrics on the specfied resource types. / except the ones excluded
    - enable all metrics
    - enable selected metrics
    - Override defaults
1. Enable metrics on the specified Reources.
    - Override defaults
1. Enable Metrics Per Workloads (Costin Way)

# Workflow
- Set tenant and subscription information in ***Config.yml***
- create a ***metric.yml*** with metric settings. this should be ready oob.
- create and put a metric arm template if necesary. 
- Create action groups in a yaml.
- Configuration Yamls
    - Create Yaml files with metric information per subscription in teach tenant directory.
    - Create Yaml files for workloads.
- Create the alerts per each yaml file mentioned in the above yaml.files

# Operations
- Update metrics with new metric.
    - In this case you need to update option one where all metrics are enabled. This is easy, each time the deployment runs it figures out the metrics
- add new action group: 
    -  In this case we need to update the related metric(s) with the specified Action group
- remove action group: 
    - find the subscription.ymls and remove the action groups. (do this programtically.)


- Main Configuration
```yml
# each Subscription should have its own SubscriptionID.Yml
Configuration:
    RootFolder: c:\Repos\ManageAzureMonitorAlerts\
    TemplatesFolder: ArmTemplates
    Tenants:
    - TenantID: yyyy 
      SubscriptionID:
      - xxx
      - zzz
    - TenantID: tttt
      SubscriptionID:
      - aaa
      - bbb  
```

- Subscription.yml - Per ResourceType - All Metrics
```yml
Configuration:
    Type : Subscription
    SubscriptionID: xxxx
    Option: PerResourceType
    AllMetrics: true
    ExcludedMetrics: 
      - metric1
      - metric2

ResourceTypes: 
    - ResourceType1
    - ResourceType2
```

- Subscription.yml - Per ResourceType - selected metrics
```yml
Configuration:
    Type : Subscription
    SubscriptionID: xxxx
    Option: PerResourceType
    AllMetrics: true
    ExcludedMetrics: 
      - metric1
      - metric2

ResourceTypes: 
    - ResourceType1
    - ResourceType2
```

- Workload.yml
```yml
Resources: 
 - ResourceID

ResourceTypes 
```

## Functions needed
- new-SubscrioptionConfig: creates a yaml file per the subsription 
- add