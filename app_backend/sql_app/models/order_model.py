
from sqlalchemy import  Column, Integer, Boolean, Float, DateTime, ForeignKey


from sql_app.base import Base
from sql_app.models.auth_model import User
from sql_app.models.product_model import Product

class Order(Base):
    __tablename__="Order"

    id = Column(Integer, primary_key=True, index=True)
    date = Column(DateTime, nullable=False)
    product = Column(Integer,ForeignKey("Product.id",ondelete="RESTRICT"),nullable=False)
    command_quantity = Column(Integer,nullable=False)
    profit = Column(Float,nullable=False)
    command_user = Column(Integer,ForeignKey("User.id",ondelete="RESTRICT"),nullable=False)
    deliver_user = Column(Integer,ForeignKey("User.id",ondelete="RESTRICT"),nullable=True)
    deliver_done = Column(Boolean,nullable=False,default=False)
