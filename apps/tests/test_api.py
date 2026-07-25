from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_health_endpoint() -> None:
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_create_and_list_event() -> None:
    payload = {
        "service": "frontend",
        "event": "user_login",
        "severity": "info",
        "description": "User logged into the operations portal.",
    }

    create_response = client.post("/events", json=payload)
    assert create_response.status_code == 201

    list_response = client.get("/events")
    assert list_response.status_code == 200
    assert len(list_response.json()) >= 1
