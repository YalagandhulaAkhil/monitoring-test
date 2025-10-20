import json
import boto3
import os

# --- Configuration ---
AWS_REGION = os.getenv("AWS_REGION", "us-east-1")
S3_BUCKET_NAME = os.getenv("OUTPUT_S3_BUCKET")  # e.g. "tf-output-bucket"
S3_KEY = os.getenv("OUTPUT_S3_KEY")  # e.g. "module-outputs/outputs_2025-10-20_10-00-00.json"
LOCAL_FILE = "downloaded_outputs.json"

def download_from_s3():
    """
    Download a module output JSON file from S3.
    """
    s3 = boto3.client("s3", region_name=AWS_REGION)
    try:
        print(f"⬇️ Downloading s3://{S3_BUCKET_NAME}/{S3_KEY}")
        s3.download_file(S3_BUCKET_NAME, S3_KEY, LOCAL_FILE)
        print(f"✅ Downloaded outputs to {LOCAL_FILE}")
    except Exception as e:
        print(f"❌ Error downloading from S3: {e}")
        exit(1)


def read_outputs():
    """
    Parse the downloaded JSON and print selected values.
    """
    try:
        with open(LOCAL_FILE, "r") as f:
            data = json.load(f)
        print("✅ Outputs loaded successfully.\n")
        for key, value in data.items():
            print(f"{key}: {value}")
        return data
    except Exception as e:
        print(f"❌ Error reading JSON: {e}")
        exit(1)


def get_output_value(output_key):
    """
    Helper function to get a specific output value.
    """
    data = read_outputs()
    return data.get(output_key)


def main():
    if not S3_BUCKET_NAME or not S3_KEY:
        print("❌ Environment variables OUTPUT_S3_BUCKET and OUTPUT_S3_KEY must be set!")
        exit(1)

    download_from_s3()
    outputs = read_outputs()

    # Example: use a specific output in a workflow
    vpc_id = outputs.get("vpc_id")
    ec2_public_ip = outputs.get("public_ip")
    print(f"\nExample: VPC ID = {vpc_id}")
    print(f"Example: EC2 Public IP = {ec2_public_ip}")


if __name__ == "__main__":
    main()
