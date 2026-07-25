import uuid
from datetime import datetime, timezone

from app.database.bigquery import TABLE, client


def create_event(event):
    row = {
        "id": str(uuid.uuid4()),
        "service": event.service,
        "event": event.event,
        "severity": event.severity,
        "description": event.description,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }

    errors = client.insert_rows_json(TABLE, [row])

    if errors:
        raise Exception(errors)

    return row


def get_events(limit: int = 20):
    query = f"""
    SELECT *
    FROM `{TABLE}`
    ORDER BY created_at DESC
    LIMIT {limit}
    """

    rows = client.query(query).result()

    return [dict(row.items()) for row in rows]