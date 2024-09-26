import snowflake.connector
import yaml
import os
import pandas as pd
import json
import requests



# edit this with the profile file location if its not in root. 
PROFILES_PATH = 'profiles.yml'

def read_profiles_yml(profile_name='default', target_name='dev'):
    with open(PROFILES_PATH, 'r') as file:
        profiles = yaml.safe_load(file)
        
    profile = profiles.get(profile_name, {})
    target = profile.get('outputs', {}).get(target_name, {})
    
    # this will read your profiles.yml and get the required information to connect
    return {
        'account': target.get('account'),
        'user': target.get('user'),
        'password': target.get('password'),
        'role': target.get('role'),
        'database': target.get('database'),
        'warehouse': target.get('warehouse'),
        'schema': target.get('schema')
    }

def get_snowflake_connection(profile_name='default', target_name='dev'):
    """Establish a connection to Snowflake using profiles.yml."""
    connection_details = read_profiles_yml(profile_name, target_name)
    
    return snowflake.connector.connect(
        user=connection_details['user'],
        password=connection_details['password'],
        account=connection_details['account'],
        warehouse=connection_details['warehouse'],
        database=connection_details['database'],
        schema=connection_details['schema'],
        role=connection_details['role']
    )

def read_slack_notifications():
    """Fetch data from the slack_notifications table."""
    try:
        conn = get_snowflake_connection()
        cur = conn.cursor()
        
        query = "SELECT source_table, missing_columns FROM dbt_output_dbt_output.slack_notifications where ACTION_TYPE = 'missing'"
        cur.execute(query)
        
        results = cur.fetchall()
        df = pd.DataFrame(results, columns=['source_table', 'missing_columns'])
        return df
    
    except snowflake.connector.errors.ProgrammingError as e:
        print(f"Snowflake error: {e}")
    
    finally:
        cur.close()
        conn.close()

def send_slack_message(message):
    webhook_url = "https://hooks.slack.com/services/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"
    payload = {"text": message}
    response = requests.post(webhook_url, data=json.dumps(payload), headers={'Content-Type': 'application/json'})
    
    if response.status_code != 200:
        raise ValueError(f"Request to Slack returned an error {response.status_code}, the response is:\n{response.text}")

if __name__ == "__main__":
    msg_df = read_slack_notifications()
    if msg_df.empty:
        print('No DATA to send messages')
    else: # ----------------- sending message only if there are any missing fields
# ----------------- this part is only to format the message in nice way 
        header = "source_table | missing_columns"
        separator = "-" * len(header)
        
        rows = [f"{row['source_table']:<12} | {row['missing_columns']}" for _, row in msg_df.iterrows()]
        formatted_text = f"{header}\n{separator}\n" + "\n".join(rows)
#-------------------------------------------------
        slack_msg = 'missing fields found on project sj \n' + formatted_text
        send_slack_message(slack_msg)