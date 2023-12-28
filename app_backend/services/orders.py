from fastapi import status
from datetime import datetime
from sqlalchemy.orm import Session
from schemas.order_schema import OrderCreate
from sql_app.models.order_model import Order
from sql_app.models.auth_model import User
from sql_app.models.product_model import Product



def transform_foreign_key(order:Order,db:Session):
    product = db.query(Product).filter(Product.id==order.product).first()
    product_name = product.product
    command_user = db.query(User).filter(User.id==Order.command_user).first()
    command_user_name = command_user.name
    deliver_user = db.query(User).filter(User.id==Order.deliver_user).first()
    deliver_user_name = None
    if deliver_user:
        deliver_user_name = deliver_user.name
    element = {
        "product" : f"{product_name}",
        "command_quantity" : f"{order.command_quantity}",
        "date" : f"{order.date}",
        "profit" : f"{order.profit}",
        "command_user" : f"{command_user_name}", 
        "deliver_user" : f"{deliver_user_name}",
        "deliver_done" : f"{order.deliver_done}"
    }
    return element


def get_all_orders(db:Session,current_user:User) -> (dict|list):
    if current_user.is_superuser:
        result = []
        orders = db.query(Order).all()
        if not orders[0]:
            return  dict(detail="no orders found", status_code=status.HTTP_404_NOT_FOUND)
        for order in orders:
            result.append(transform_foreign_key(order=order,db=db))
        return result
    return dict(detail="unauthorized user", status_code=status.HTTP_401_UNAUTHORIZED)


def create_new_order(db:Session,current_user:User,order:OrderCreate):
        try:
            product = db.query(Product).filter(Product.product==order.product).first()
            if order.command_quantity > product.quantity:
                return dict(detail="not enough quantity",status_code=status.HTTP_403_FORBIDDEN)
            product_id = product.id
            profit = (product.sell_price-product.buy_price)*order.command_quantity
            order = Order(
                date = datetime.now(),
                product = product_id,
                command_quantity = order.command_quantity,
                profit = profit,
                command_user = current_user.id)
            db.add(order)
            product.quantity -= order.command_quantity
            db.commit()
            db.refresh(order)
            return {"response" : "Order added successfully"}
        except:
            return dict(detail="databse error",status_code=status.HTTP_400_BAD_REQUEST)



def deliver_order(db:Session,current_user:User,user:int):
    if current_user.is_superuser:
        try:
            orders = db.query(Order).filter(Order.command_user==user).filter(Order.deliver_done==0).all()
            for order in orders:
                order.deliver_done = True
                order.deliver_user = current_user.id
                db.commit()
            return {"response" : "Orders delivery confirmed"}
        except:
            return dict(detail="databse error",status_code=status.HTTP_400_BAD_REQUEST)
    return dict(detail="unauthorized user", status_code=status.HTTP_401_UNAUTHORIZED)


def order_by_product(db:Session,current_user:User,product:int):
    if current_user.is_superuser:
        result = []
        orders = db.query(Order).filter(Order.product==product).all()
        if not orders:
            return dict(detail="no orders found", status_code=status.HTTP_404_NOT_FOUND)
        for order in orders:
            result.append(transform_foreign_key(order=order,db=db))
        return result      
    return dict(detail="unauthorized user", status_code=status.HTTP_401_UNAUTHORIZED)


def order_by_user(db:Session,current_user:User,user:int):
    if current_user.is_superuser:
        result = []
        orders = db.query(Order).filter(Order.command_user==user).all()
        if not orders:
            return dict(detail="no orders found", status_code=status.HTTP_404_NOT_FOUND)
        for order in orders:
            result.append(transform_foreign_key(order=order,db=db))
        return result
    return dict(detail="unauthorized user", status_code=status.HTTP_401_UNAUTHORIZED)

    


