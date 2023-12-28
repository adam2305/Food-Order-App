
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from config import settings
from sql_app.base import Base
from sql_app.database import engine
from sql_app import base
from routers.base_router import api_router


def create_tables() -> None:         
	base.Base.metadata.create_all(bind=engine,checkfirst=True)
    

def include_router(app: FastAPI) -> None:
    app.include_router(api_router)
    app.mount("/static", StaticFiles(directory="static"), name="static")
	
def start_application() -> FastAPI:
    create_tables()
    app = FastAPI(title=settings.PROJECT_NAME,version=settings.PROJECT_VERSION)
    include_router(app)
    return app

app = start_application()


      

