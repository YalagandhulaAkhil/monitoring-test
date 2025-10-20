import json
import subprocess
import boto3
import os
from datetime import datetime

# --- Configuration ---
OUTPUT_FILE = "terraform_outputs.json"
AWS_REGION = os.getenv("AWS_REGION", "us-east-1")
S3_BUCKET_NAME = os.getenv("OUTPUT_S3_BUCKET")  # bucket name passed via env var
S3_KEY_PREFIX = "module-outputs/"


def get_terraform_outputs():
    """
    Run 'terraform output -json' and parse the result.
    """
    try:
        result = subprocess.run(
            ["terraform", "output", "-json"],
            capture_output=True,
            text=True,
            check=True
        )
        outputs = json.loads(result.stdout)
        parsed_outputs = {k: v["value"] for k, v in outputs.items()}
        return parsed_outputs
    except subprocess.CalledProcessError as e:
        print("❌ Error running terraform output:", e.stderr)
        exit(1)


def save_to_local_file(outputs):
    """
    Save outputs to a local JSON file.
    """
    with open(OUTPUT_FILE, "w") as f:
        json.dump(outputs, f, indent=2)
    print(f"✅ Saved outputs locally to {OUTPUT_FILE}")


def upload_to_s3(outputs):
    """
    Upload the JSON file to S3.
    """
    s3 = boto3.client("s3", region_name=AWS_REGION)
    timestamp = datetime.utcnow().strftime("%Y-%m-%d_%H-%M-%S")
    s3_key = f"{S3_KEY_PREFIX}outputs_{timestamp}.json"

    try:
        s3.upload_file(OUTPUT_FILE, S3_BUCKET_NAME, s3_key)
        print(f"✅ Uploaded {OUTPUT_FILE} to s3://{S3_BUCKET_NAME}/{s3_key}")
    except Exception as e:
        print(f"❌ Error uploading file to S3: {e}")


def main():
    if not S3_BUCKET_NAME:
        print("❌ Environment variable OUTPUT_S3_BUCKET not set!")
        exit(1)

    outputs = get_terraform_outputs()
    save_to_local_file(outputs)
    upload_to_s3(outputs)


if __name__ == "__main__":
    main()
