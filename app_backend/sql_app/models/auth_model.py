from datetime import datetime
import enum
from sqlalchemy import Column, Integer, String, Boolean, Float, Date, Enum

from sql_app.base import Base


class roles(enum.Enum):
    ADMIN = 'ADMIN'
    COTISANT = 'COTISANT'
    BUREAU = 'BUREAU'
    SERVEUR = 'SERVEUR'
    STOCK = 'STOCK'

class User(Base):
    __tablename__ ="User"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(40), nullable=False,unique=True)
    email = Column(String(50), nullable=False, unique=True, index=True)
    password = Column(String(40), nullable=False)
    is_superuser = Column(Boolean(), default=False,nullable=False)
    role = Column(Enum(roles,name="roles_types"), nullable=False,default="COTISANT")
    promotion = Column(String(20), nullable=False) 
    deposit = Column(Float,nullable=False, default=0)
    creation_date = Column(Date, nullable=False, default=datetime.now().date())

