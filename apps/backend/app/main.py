from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.events import router as event_router

app = FastAPI(
    title="Enterprise Multi-Cloud Analytics Platform",
    version="1.0.0",
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
    "http://localhost:8080",
    "http://127.0.0.1:8080",
    "https://lemon-moss-02b6abe10.7.azurestaticapps.net",

    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(event_router)


@app.get("/")
def root():
    return {
        "application": "Enterprise Multi-Cloud Analytics Platform",
        "status": "running",
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }