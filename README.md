Initialize Terraform object names with CSV values

Tree of project :
```
├── environments
│   └── prd
│       └── resources.csv
├── get_variables.sh
├── main.tf
├── modules
│   └── global
│       └── main.tf
└── templates
    └── sample.tf.source
```

CSV files must be in those folders : environments/xxx/resources.csv  (xxx values are prd, dev, int, uat, etc...)

CSV File Format :
- First column = terraform object name
- Second column = azure object name

Sample CSV File : 
```
cat environments/prd/resources.csv

local_name, resource_name
sqlserver1, sql-pp-dbi-1
storeabcd1234, azstoipalog1
```

1) Launch ./get_variables.sh -e [--environment] prd|uat|dev|int
2) terraform init
3) terraform plan

Sample output :
```
Changes to Outputs:
  + out1 = {
      + sqlserver1    = "sql-pp-dbi-1"
      + storeabcd1234 = "azstoipalog1"
      + webapp01      = "DEFAULTwebapp01"
    }
```

Values staying with DEFAULT in the name = parameter not set in CSV file

Hwo to use : In other modules, use global.naming.sqlserver1 for example to get the name "sql-pp-dbi-1"
