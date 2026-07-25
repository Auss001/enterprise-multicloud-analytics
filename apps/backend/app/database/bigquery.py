import json
import os

from google.cloud import bigquery
from google.oauth2 import service_account

from app.core.config import settings


def create_bigquery_client() -> bigquery.Client:
    service_account_json = os.getenv("GCP_SERVICE_ACCOUNT_JSON")

    if service_account_json:
        service_account_info = json.loads(service_account_json)

        credentials = service_account.Credentials.from_service_account_info(
            service_account_info
        )

        return bigquery.Client(
            project=settings.PROJECT_ID,
            credentials=credentials,
        )

    return bigquery.Client(project=settings.PROJECT_ID)


client = create_bigquery_client()

TABLE = (
    f"{settings.PROJECT_ID}."
    f"{settings.DATASET_ID}."
    f"{settings.TABLE_ID}"
)