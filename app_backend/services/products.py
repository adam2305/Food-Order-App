from fastapi import status
from typing import List

from schemas.product_schema import ProductCreate
from sqlalchemy.orm import Session
from sql_app.models.product_model import Product
from sql_app.models.auth_model import User


def get_all_product(db:Session):
    products = db.query(Product)
    if not products.first():
        return dict(detail="no users found", status_code=status.HTTP_304_NOT_MODIFIED)
    return products.all()


def create_new_product(db:Session, current_user:User, product:ProductCreate):
    if current_user.is_superuser:
        product = Product(
            product = product.product,
            category = product.category,
            buy_price = product.buy_price,
            sell_price = product.sell_price,
            nutrition = product.nutrition,
            image = product.image,
            description = product.description
            ) 
        db.add(product)
        db.commit()
        db.refresh(product)
        return dict(detail="new product created", status_code=status.HTTP_201_CREATED)
    return dict(detail="unauthorized user", status_code=status.HTTP_401_UNAUTHORIZED)

def get_product_by_product(product_search:str, db:Session) -> (Product|dict):
    product = db.query(Product).filter(Product.product==product_search)
    if not product.first():
        return dict(detail="no product found", status_code=status.HTTP_404_NOT_FOUND)
    return product.first()

def get_product_by_category(category:str, db:Session) -> (List[Product]|dict):
    product = db.query(Product).filter(Product.category==category)
    if not product.first():
        return dict(detail="no products found", status_code=status.HTTP_404_NOT_FOUND)
    return product.all()

def update_product_quantity(product_name:str,quantity:int,db:Session,current_user:User) -> dict:
    if current_user.is_superuser:
        product=db.query(Product).filter(Product.product==product_name).first()
        if not product:
            return dict(detail="no product found", status_code=status.HTTP_404_NOT_FOUND)
        if product.quantity + quantity >= 0:
            product.quantity += quantity
            db.commit()
            return {"response" : "qauntity successfully updated"}
        return dict(detail="insufficent quantity", status_code=status.HTTP_406_NOT_ACCEPTABLE)
    return dict(detail="unauthorized user", status_code=status.HTTP_401_UNAUTHORIZED)

def change_buy_price(product_name:str,buy_price:float,db:Session,current_user:User):
    if current_user.is_superuser:
        product=db.query(Product).filter(Product.product==product_name).first()
        if not product:
            return dict(detail="no product found", status_code=status.HTTP_404_NOT_FOUND)
        product.buy_price = buy_price
        db.commit()
        return {"response" : "buy_price successfully updated"}
    return dict(detail="unauthorized user", status_code=status.HTTP_401_UNAUTHORIZED)

def change_sell_price(product_name:str,sell_price:float,db:Session,current_user:User):
    if current_user.is_user_superuser:
        product=db.query(Product).filter(Product.product==product_name).first()
        if not product:
            return dict(detail="no product found", status_code=status.HTTP_404_NOT_FOUND)
        product.buy_price = sell_price
        db.commit()
        return {"response" : "sell_price successfully updated"}
    return dict(detail="unauthorized user", status_code=status.HTTP_401_UNAUTHORIZED)

def delete_product(product_name:str,db:Session,current_user:User):
    if current_user.is_superuser:
        product=db.query(Product).filter(Product.product==product_name)
        if not product:
            return dict(detail="no product found", status_code=status.HTTP_404_NOT_FOUND)
        product.delete()
        db.commit()
        return {"response" : "successfully deleted"}
    return dict(detail="unauthorized user", status_code=status.HTTP_401_UNAUTHORIZED)