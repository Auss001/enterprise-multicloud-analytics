from fastapi import APIRouter

from app.schemas.event import EventCreate
from app.services.event_service import create_event, get_events

router = APIRouter(prefix="/events", tags=["Events"])


@router.post("")
def create(event: EventCreate):
    return create_event(event)


@router.get("")
def read():
    return get_events()