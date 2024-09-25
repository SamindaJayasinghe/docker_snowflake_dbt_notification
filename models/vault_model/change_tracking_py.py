import pandas as pd
import requests
import json

def model(dbt, session):

    # This is how we make a python dbt model
    orders_df = dbt.ref('change_tracking')

    column_list = ['AGE', 'CABIN', 'EMBARKED', 'FARE', 'NAME', 'PARCH', 'PASSENGERID', 'PCLASS', 'SEX', 'SIBSP','SURVIVED']

    orders_df = orders_df.to_pandas()

    missing_columns = set(column_list).difference(orders_df.columns)
    print(missing_columns)
        
    # webhook_url = "https://hooks.slack.com/services/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"
    # payload = {"text": missing_columns}
    # response = requests.post(webhook_url, data=json.dumps(payload), headers={'Content-Type': 'application/json'})
    
    # if response.status_code != 200:
    #     raise ValueError(f"Request to Slack returned an error {response.status_code}, the response is:\n{response.text}")


    return orders_df