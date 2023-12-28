import os
from dotenv import load_dotenv
from pathlib import Path


env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path)


class Settings:
    PROJECT_NAME:str = os.getenv("PROJECT_NAME")
    PROJECT_VERSION: str = os.getenv("PROJECT_VERSION")

    DATABASE_URL = "sqlite:///./comif.db"

    ACCESS_TOKEN_EXPIRE_MINUTES = os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES")
    ALGORITHM = os.getenv("ALGORITHM")
    SECRET_KEY :str = os.getenv("JWT_SECRET_KEY")

    ROLES:list = os.getenv("ROLES")
    CATEGORY:list = os.getenv("CATEGORY")

settings = Settings()