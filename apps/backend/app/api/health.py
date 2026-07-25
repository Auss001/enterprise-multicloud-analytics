from fastapi import APIRouter

from app.core.config import settings


router = APIRouter(tags=["system"])


@router.get("/")
def root() -> dict[str, str]:
    return {
        "application": settings.application_name,
        "version": settings.application_version,
        "environment": settings.environment,
        "status": "running",
    }


@router.get("/health")
def health() -> dict[str, str]:
    return {
        "status": "healthy",
        "service": "backend",
    }
