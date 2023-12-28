from fastapi import APIRouter, HTTPException, status, Depends
from sqlalchemy.orm import Session
from typing import List,Any

from schemas.order_schema import OrderCreate
from services.security import get_current_user
from services.orders import (get_all_orders,create_new_order,
                             deliver_order,order_by_product,
                             order_by_user)
from sql_app.database import get_db
from sql_app.models.auth_model import User
from sql_app.models.order_model import Order

router = APIRouter()

@router.get("/orders",
            status_code=status.HTTP_200_OK,
            response_model=dict|list,
            summary="Get all orders",
            description="ADMIN required\r\nAUTHENTICATION required")
def get_all_order(db:Session=Depends(get_db), current_user:User=Depends(get_current_user)):
    try:
        response = get_all_orders(db=db,current_user=current_user)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)
    

@router.get("/orders/user/{user_id}",
            status_code=status.HTTP_200_OK,
            response_model=list|dict,
            summary="Get orders by user_id",
            description="ADMIN required\r\nAUTHENTICATION required")
def get_orders_by_user(user_id:int,db:Session=Depends(get_db), current_user:User=Depends(get_current_user)):
    try:
        response = order_by_user(db=db,current_user=current_user,user=user_id)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)


@router.get("/orders/product/{product}",
            status_code=status.HTTP_200_OK,
            response_model=list|dict,
            summary="Get orders by product",
            description="ADMIN required\r\nAUTHENTICATION required")
def get_orders_by_product(product:int,db:Session=Depends(get_db), current_user:User=Depends(get_current_user)):
    try:
        response = order_by_product(db=db,current_user=current_user,product=product)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)


@router.put("/orders/deliver_order/{user_id}",
            status_code=status.HTTP_200_OK,
            response_model=list|dict,
            summary="Confirm order delivery",
            description="ADMIN required\r\nAUTHENTICATION required")
def confirm_order_delivery(user:int, db:Session=Depends(get_db), current_user:User=Depends(get_current_user)):
    try:
        response = deliver_order(db=db,current_user=current_user,user=user)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)


@router.post("/orders/new_order",
             status_code=status.HTTP_201_CREATED,
             response_model=list|dict,
             summary="Create new order",
             description="AUTHENTICATION required")
def add_new_order(order:OrderCreate,db:Session=Depends(get_db),current_user:User=Depends(get_current_user)):
    try:
        response = create_new_order(db=db,current_user=current_user,order=order)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)
    


    

    

