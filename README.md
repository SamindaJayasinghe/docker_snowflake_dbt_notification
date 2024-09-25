docker build 
in docker --> dbt compile --profiles-dir . --no-version-check

dbt compile --profiles . --no-version-check

dbt deps --profiles . --no-version-check

1. Create a Slack Webhook
First, you need to set up an Incoming Webhook in Slack:

Go to your Slack workspace.
Navigate to Apps → Manage apps.
Search for "Incoming Webhooks" and add it to your workspace.
Create a webhook and copy the webhook URL that Slack generates for you.

 to execute python file --> python slack2.py



=========================== This is how this project works 
 1st approach
In this will capture the missing fields and save on the terminal memory

Python slack.py will send notifications to the slack

Note : you dont even need to run the dbt project to find out whats missing, 
If you have configure things on macros/new_macro ,
It will show you if something is missing.

This approach is good to check a one specific table




2nd Approach proposal for production use

First run this to create a table inside your schema with data types in it ( check with client if thats ok )
dbt run --profiles-dir . --models slack_notifications → to build the place holder for notification logs , 
(Note - this table will not grow, meaning every run it will drop and re-create ) 


Second run this to create the source table, any table you want , while its creating, 
At the same time this will insert any missing fields on the above table 
dbt run --profiles-dir . --models change_tracking_tbl

Then to get the slack message 
python slack2.py → this can be run after the entire dbt run complete. 

In this approach , we can configure all the tables in epamaral by defining the tables fields lists, 
Like in change_tracking_tbl
And refer them as var in the dbt project for reference tables. 

While its building the model , this will capture any missing values, 

Then after dbt complete, it shows all the missing values with table name and field. 
After Receiving the message whats the next step to correct 
—-----------------------------------------------------
Then ,
When the developer receive this , he could visit the code in dbt 
And add the fields in the appropriate model 
{% set column_list = ['AGE', 'CABIN', 'EMBARKED', 'FARE', 'NAME', 'PARCH', 'SEX', 'SIBSP','SURVIVED', 'PASSENGERID', 'TICKET'] %}

And re-run the project 


Dbt python models → Additional Approach 

This is to show the new python models, 

Pls review change_tracking_py
