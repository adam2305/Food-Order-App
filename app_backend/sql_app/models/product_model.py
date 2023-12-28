import enum
from sqlalchemy import  Column, Integer, String, Float, Enum

from sql_app.base import Base

class categories(enum.Enum):
    VINS = 'VINS',
    SOFTS = 'SOFTS',
    BIERES = 'BIERES',
    APERITIFS = 'APERITIFS',
    VIENN = 'VIENN',

class Product(Base):
    __tablename__ = "Product"

    id = Column(Integer, primary_key=True, index=True)
    product = Column(String(50),nullable=False,unique=True)
    image = Column(String(50),nullable=False)
    category = Column(Enum(categories,name="categories_types"), nullable=False)
    description = Column(String(100),nullable=False)
    nutrition = Column(String(50),nullable=False)
    quantity = Column(Integer,nullable=False, default=0)
    buy_price = Column(Float,nullable=False)
    sell_price = Column(Float,nullable=False)