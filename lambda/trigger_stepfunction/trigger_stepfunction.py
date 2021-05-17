import os
import boto3


def lambda_handler(event, context):
    STEPFUNCTION_ARN = os.environ["STEPFUNCTION_ARN"]

    print(event)

    insert_event = [i for i in event["Records"] if i["eventName"] == "INSERT"]

    if not len(insert_event):
        print("Skipping trigger lambda for non INSERT event")
        return

    client = boto3.client('stepfunctions')

    response = client.start_execution(
        stateMachineArn=STEPFUNCTION_ARN
    )
    return True
