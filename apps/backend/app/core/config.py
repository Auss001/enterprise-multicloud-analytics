from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    PROJECT_ID: str = "flawless-window-499104-u9"
    DATASET_ID: str = "ema_dev_events"
    TABLE_ID: str = "raw_events"

    class Config:
        env_file = ".env"


settings = Settings()