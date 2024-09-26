docker build 
open docker desktop --> download this repo--> open it in vscode --> install docker extension > right click on docker file --> click build image --> click on docker icon --> check under images and right click and "run intractive"
this will build the docker container --> right click on it --> and click "attach visual studio code" --> this will open a separate window.
when you open it for the first time you have to click on root, find your project folder, and open inside the docker 

pre requirement : 
docker desktop
docker extension installed in vs code
1. Create a Slack Webhook ( you need to set up an Incoming Webhook in Slack: ) 

Go to your Slack workspace.
Navigate to Apps → Manage apps.
Search for "Incoming Webhooks" and add it to your workspace.
Create a webhook and copy the webhook URL that Slack generates for you.


=====================================
1st Approach. Send Slack notifications without running the DBT project 


in the terminal type "python slack.py" and it will send missing columns in the source table

description 
inside Python script it will execute "macros/new_macro" ( check dbt run-operation --new_macro ) 
in the new_macro --> it reads the source table and compares it with the pre-defined list ( column_list ) 
and prepare message1 ( containing all missing columns ) and return it

python app will capture the returned message and send it to Slack 

good :
this is good for identifying columns before running the dbt-project
bad :
every table has to be configured on a macro
if you want to check all the tables, you have to configure them separately


=====================================
2nd Approach. Send Slack notifications after dbt run 

How this works

First we create a table to capture missing columns (Note - this table will not grow, meaning every run it will drop and re-create ) 
	dbt run --profiles-dir . --models slack_notifications


Then prepare the scripts to listing the desired columns ( you can build base tables with the same code ) 
	dbt run --profiles-dir . --models change_tracking_tbl

After the completion of dbt run
	python slack2.py 

While its building the model, this will capture any missing values, 

Then after dbt complete, it shows all the missing values with table name and field. 

======================================================================================================
How to correct dbt after detecting the missing columns
===================================================================================================== 

After Receiving the message whats the next step to correct 
—-----------------------------------------------------
message will show you what model to look in the dbt, just add the column to the column_list

And add the fields in the appropriate model 
{% set column_list = ['AGE', 'CABIN', 'EMBARKED', 'FARE', 'NAME', 'PARCH', 'SEX', 'SIBSP','SURVIVED', 'PASSENGERID', 'TICKET'] %}

And re-run the project 

======================================================================================================
Additional finding --> How build dbt models in python. ( without jinja ) 
===================================================================================================== 
Pls review change_tracking_py 

to execute dbt run --profiles-dir . --models change_tracking_py
