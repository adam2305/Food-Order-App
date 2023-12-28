from fastapi import APIRouter, HTTPException, status, Depends
from config import settings
from sqlalchemy.orm import Session
from typing import List, Any

from schemas.product_schema import ProductShow,ProductCreate
from services.products import (get_all_product, 
                               create_new_product,
                               get_product_by_product, 
                               get_product_by_category,
                               update_product_quantity,
                               change_buy_price,
                               change_sell_price, 
                               delete_product)
from services.security import get_current_user
from sql_app.database import get_db
from sql_app.models.auth_model import User


category = settings.CATEGORY

router = APIRouter()


@router.get("/products",
            response_model=List[ProductShow],
            status_code=status.HTTP_200_OK,
            summary= "Get all products",
            description= "FREE access")
def get_all_products(db:Session=Depends(get_db)):
    try:
        products = get_all_product(db=db)
        return products
    except:
        raise HTTPException(detail="something went wrong",status_code=status.HTTP_400_BAD_REQUEST)


@router.get("/products/product/{product}",
            response_model=ProductShow|dict,
            status_code=status.HTTP_200_OK,
            summary= "Get products by product name",
            description= "AUTHENTICATION required")
def get_products_by_product(product:str, db:Session=Depends(get_db)):
    try:
        products = get_product_by_product(db=db,product_search=product)
        return products
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)


@router.get("/products/category/{category}",
            response_model=List[ProductShow]|dict,
            status_code=status.HTTP_200_OK,
            summary= "Get products by category",
            description= "AUTHENTICATION required")
def get_products_by_category(category:str, db:Session=Depends(get_db)):
    try:
        products = get_product_by_category(category=category,db=db)
        return products
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)


@router.post("/products",
             response_model=dict,
             status_code=status.HTTP_200_OK,
             summary= "Create new product",
             description= "AUTHENTICATION required\r\nADMIN required")
def add_new_product(product:ProductCreate ,db:Session=Depends(get_db), current_user:User=Depends(get_current_user)):
    try:
        response = create_new_product(db=db,current_user=current_user,product=product)
        return response
    except:
        raise HTTPException(detail="something went wrong",status_code=status.HTTP_400_BAD_REQUEST)
    

@router.put("/products/quantity/{product}",
            response_model=dict,
            status_code=status.HTTP_200_OK,
            summary= "Update product quantity",
            description= "AUTHENTICATION required\r\nADMIN required")
def chnage_product_quantity(product:str,quantity:int,db:Session=Depends(get_db),current_user:User=Depends(get_current_user)):
    try:
        response = update_product_quantity(product_name=product,quantity=quantity,db=db,current_user=current_user)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)
    

@router.put("/products/buy_price/{product}",
            response_model=dict,
            status_code=status.HTTP_200_OK,
            summary= "Change product buy_price",
            description= "AUTHENTICATION required\r\nADMIN required")
def chnage_product_buy_price(product:str,buy_price:float,db:Session=Depends(get_db),current_user:User=Depends(get_current_user)):
    try:
        response = change_buy_price(product_name=product,buy_price=buy_price,db=db,current_user=current_user)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)
    

@router.put("/products/sell_price/{product}",
            status_code=status.HTTP_200_OK,
            response_model=dict,
            summary= "Change product sell_price",
            description= "AUTHENTICATION required\r\nADMIN required")
def chnage_product_quantity(product:str,buy_price:float,db:Session=Depends(get_db),current_user:User=Depends(get_current_user)):
    try:
        response = change_sell_price(product_name=product,buy_price=buy_price,db=db,current_user=current_user)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)
    

@router.delete("/products/delete/{product}",
               status_code=status.HTTP_200_OK,
               response_model=dict,
               summary= "Delete product",
                description= "AUTHENTICATION required\r\nADMIN required")
def delete_products(product:str,db:Session=Depends(get_db),current_user:User=Depends(get_current_user)):
    try:
        response = delete_product(product_name=product,db=db,current_user=current_user)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)
    