import base64
import boto3
import json
import random
import os

# Initialiserer AWS-klienter for både bedrock og s3
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

MODEL_ID = "amazon.titan-image-generator-v1"
BUCKET_NAME = os.environ["BUCKET_NAME"]
PATH_PREFIX = os.environ["S3_IMAGE_PATH_PREFIX"]

def lambda_handler(event, context):
    # Går gjennom alle meldinger fra SQS i eventet
    for record in event["Records"]:
        # Henter meldingsinnhold fra SQS
        prompt = record["body"]
        seed = random.randint(0, 2147483647)
        s3_image_path = f"{PATH_PREFIX}titan_{seed}.png"

        # Setter opp forespørsel for bildegenerering
        native_request = {
            "taskType": "TEXT_IMAGE",
            "textToImageParams": {"text": prompt},
            "imageGenerationConfig": {
                "numberOfImages": 1,
                "quality": "standard",
                "cfgScale": 8.0,
                "height": 512,
                "width": 512,
                "seed": seed,
            },
        }

        # Kaller til Bedrock-modellen for å generere bildet
        response = bedrock_client.invoke_model(
            modelId=MODEL_ID,
            body=json.dumps(native_request)
        )

        model_response = json.loads(response["body"].read())
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        # Laster opp det genererte bildet til S3
        s3_client.put_object(Bucket=BUCKET_NAME, Key=s3_image_path, Body=image_data)

    # Returnerer statuskode og en suksessmelding
    return {
        "statusCode": 200,
        "body": json.dumps("Images successfully uploaded!")
    }
