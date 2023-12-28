## CODE VERIFIED

from fastapi import status
from sqlalchemy.orm import Session
from typing import List

from schemas.users_schema import UserCreate
from sql_app.models.auth_model import User
from .security import Hasher


def create_new_user(user:UserCreate,db:Session, current_user:User) -> dict:
    if current_user.is_superuser:
        user = User(name = user.name,
                    email = user.email,
                    password = Hasher.get_password_hash(user.password),
                    is_superuser = False,
                    role = user.role,
                    promotion = user.promotion)
        try:
            db.add(user)
            db.commit()
            db.refresh(user)
            return {"name" : f"{user.name}",
                    "promotion" : f"{user.promotion}",
                    "role" : f"{user.role}"}
        except:
            return dict(detail="database commit error",status_code=status.HTTP_400_BAD_REQUEST)
    return dict(detail="unauthorized user",status_code=status.HTTP_401_UNAUTHORIZED)


def show_user_all(db:Session) -> (List[User]|dict):
    users = db.query(User)
    if not users.first():
        return dict(detail="no users found", status_code=status.HTTP_200_OK)
    return users.all()


def delete_user(name:str, db:Session, current_user:User) -> dict:
    if current_user.is_superuser:
        user = db.query(User).filter(User.name==name)
        if not user.first():
            return {"error":f"user {name} not found"}
        user.delete()
        db.commit()
        return {"response":f"deleted user {name}"}
    return {"error":f"unauthorized action "}


def get_user_by_role(db:Session, role:str) -> (List[User]|dict):
    users = db.query(User).filter(User.role==role)
    if not users.first():
        return dict(detail="no users found", status_code=status.HTTP_200_OK)
    return users.all()


def get_user_by_promotion(db:Session,promotion:str) -> (List[User]|dict):
    users = db.query(User).filter(User.promotion==promotion)
    if not users.first():
        return dict(detail="no users found", status_code=status.HTTP_200_OK)
    return users.all()


def update_user_deposit(db:Session,user:User,deposit:float,current_user:User) -> dict:
    if current_user.is_superuser:
        if user.deposit+deposit >= 0.0:
            user.deposit += deposit
            db.commit()
            return {"name" : f"{user.name}",
                    "deposit" : f"{user.deposit}"}
        return dict(detail="impossible insufficent funds", status_code=status.HTTP_304_NOT_MODIFIED)  
    return {"detail" : "unauthorized user",}


