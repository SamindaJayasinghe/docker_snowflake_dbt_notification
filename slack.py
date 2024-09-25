import requests
import json
import sys
import subprocess

def send_slack_message(message, webhook_url):
    payload = {"text": message}
    response = requests.post(webhook_url, data=json.dumps(payload), headers={'Content-Type': 'application/json'})
    
    if response.status_code != 200:
        raise ValueError(f"Request to Slack returned an error {response.status_code}, the response is:\n{response.text}")

if __name__ == "__main__":
    slack_webhook_url = "https://hooks.slack.com/services/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"

    result = subprocess.run(['dbt', 'run-operation', 'new_macro'], capture_output=True, text=True)
    str_result = result.stdout
    phrase = "All missing columns"
    start_index = str_result.find(phrase)

    if start_index != -1:
        # Calculate the start index of the value after the phrase
        start_index += len(phrase)
        # Slice the string to get the value after the phrase
        value = str_result[start_index:].strip().split('.')[0]  # Assuming it ends with a period
        message = 'missing fields found on project sj-->titanic tbl-->' + value
        send_slack_message(message, slack_webhook_url)
    else:
        print("Phrase not found.")
        value = "No Missing Columns"

    print('I am here')
    