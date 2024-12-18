import base64
import boto3
import json
import os
import random
from botocore.exceptions import BotoCoreError, ClientError

# Initialiserer AWS-klienter
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

# Henter bøttenavn og kandidatnummer fra miljøvariabler
bucket_name = os.getenv("BUCKET_NAME")
candidate_number = os.getenv("CANDIDATE_NUMBER")
model_id = "amazon.titan-image-generator-v1"

def lambda_handler(event, context):
    # Leser prompt fra forespørselens kropp
    try:
        body = json.loads(event['body'])
        prompt = body.get("prompt", "")
        if not prompt:
            raise ValueError("Prompt is required")
    except (json.JSONDecodeError, ValueError) as e:
        return {"statusCode": 400, "body": json.dumps({"error": str(e)})}

     # lager et tilfeldig seed for bildegenerering
    seed = random.randint(0, 2147483647)
    s3_image_path = f"{candidate_number}/generated_images/titan_{seed}.png"

    # Oppretter forespørselspayload for Bedrock-modellen
    native_request = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "quality": "standard",
            "cfgScale": 8.0,
            "height": 1024,
            "width": 1024,
            "seed": seed,
        }
    }

    # Kaller Bedrock-modellen
    try:
        response = bedrock_client.invoke_model(
            modelId=model_id,
            body=json.dumps(native_request)
        )
        model_response = json.loads(response["body"].read())
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)
    except (BotoCoreError, ClientError, KeyError) as error:
        return {"statusCode": 500, "body": json.dumps({"error": str(error)})}

    # Laster opp bildet til S3
    try:
        s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)
    except (BotoCoreError, ClientError) as error:
        return {"statusCode": 500, "body": json.dumps({"error": str(error)})}

    # Returnerer S3 URI for det opplastede bildet
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Image generated successfully",
            "s3_uri": f"s3://{bucket_name}/{s3_image_path}"
        })
    }
