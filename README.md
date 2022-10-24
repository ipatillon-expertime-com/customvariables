Initialize Terraform object names with CSV values

Tree of project :
```
├── get_variables.sh
├── main.tf
├── modules
│   └── global
│       └── main.tf
├── templates
│   └── sample.tf.source
└── environments
    ├── prd
    │   └── resources.csv
    ├── int
    │   └── resources.csv
    └── dev
        └── resources.csv
 
```

CSV files must be in those folders : environments/xxx/resources.csv  (xxx values are prd, dev, int, uat, etc...)

CSV File Format :
- First column = terraform object name
- Second column = azure object name

Sample CSV File : 
```
cat environments/prd/resources.csv

local_name, resource_name
sqlserver1, sql-pp-db-1
store1, stojpaduxe34561
```

1) Launch ./get_variables.sh -e [--environment] prd|uat|dev|int

this copy the sample.tf.source into main.tf in the global folder and changes variables values with the resources.csv in the $ENV folder

2) terraform init
3) terraform plan

Sample output :
```
Changes to Outputs:
  + naming = {
      + sqlserver1    = "sql-pp-db-1"
      + store1        = "stojpaduxe34561"
      + webapp01      = "DEFAULTwebapp01"
    }
```

Values staying with DEFAULT in the name = parameter not set in CSV file

How to use in Terraform: In other modules, use global.naming.sqlserver1 for example to get the name "sql-pp-dbi-1"
