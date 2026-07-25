from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class EventCreate(BaseModel):
    service: str
    event: str
    severity: str
    description: str


class EventResponse(EventCreate):
    id: str
    created_at: Optional[datetime] = None