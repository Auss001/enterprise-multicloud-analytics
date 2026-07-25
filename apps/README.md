# Enterprise Multi-Cloud Operations Analytics Backend

FastAPI backend for the Enterprise Multi-Cloud Operations Analytics Platform.

## Endpoints

- `GET /`
- `GET /health`
- `POST /events`
- `GET /events`
- `GET /docs`

## Build the ARM64 Docker image

```powershell
docker build --platform linux/arm64 -t ema-backend:v1 .
```

## Run locally

```powershell
docker run --rm -p 8000:8000 --name ema-backend ema-backend:v1
```

## Test the health endpoint

```powershell
Invoke-RestMethod http://localhost:8000/health
```

## Open the API documentation

```text
http://localhost:8000/docs
```

## Run with Docker Compose

```powershell
docker compose up --build
```

## Run automated tests locally

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements-dev.txt
pytest
```

The current event store is intentionally in memory. PostgreSQL through Amazon RDS Proxy will replace it in the next application version.
