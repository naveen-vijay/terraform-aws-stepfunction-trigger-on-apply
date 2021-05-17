from diagrams import Cluster, Diagram, Edge
from diagrams.aws.database import DynamodbTable, DynamodbItem
from diagrams.aws.compute import LambdaFunction
from diagrams.custom import Custom
from diagrams.aws.integration import StepFunctions

with Diagram("terraform-aws-stepfunction-trigger-on-apply", show=False, outformat="jpg",
             filename="architecture-diagram"):
    with Cluster("Terraform Module"):
        with Cluster("Timestamp DynamoDB Item"):
            timestamp_item = Custom("Timestamp", "./images/time.png") >> Edge(
                label="upserted \n on every \n TF Apply") >> DynamodbItem(
                "DynamodbItem")

        with Cluster("Trigger Handler"):
            dynamodb_table = DynamodbTable("DynamoDB Table")
            trigger_handler = dynamodb_table >> Edge(label="Insert Trigger") >> LambdaFunction(
                label="Uses the \n StepFunction ARN \n input") >> Edge(label="starts the execution") >> StepFunctions(
                "Step Function")

    timestamp_item >> Edge(label="Contains") >> dynamodb_table
