## CODE VERIFIED

from fastapi import APIRouter, HTTPException, status, Depends
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from typing import List

from schemas.token_schema import Token
from schemas.users_schema import UserCreate, UserShow
from services.security import (authenticate_user, 
                               create_access_token, 
                               get_current_user,
                               get_user)
from services.users import (create_new_user,
                            show_user_all, 
                            delete_user, 
                            update_user_deposit,
                            get_user_by_promotion, 
                            get_user_by_role)
from sql_app.database import get_db
from sql_app.models.auth_model import User


router = APIRouter()


@router.get("/users",
            response_model = List[UserShow]|dict,
            status_code = status.HTTP_200_OK,
            summary = "Get all users",
            description = "AUTHENTICATION required",
            dependencies = [Depends(get_current_user)])
def show_all_users(db:Session=Depends(get_db)):
    try:
        response = show_user_all(db=db)
        return response
    except:
        raise HTTPException(detail = "something went wrong", status_code=status.HTTP_400_BAD_REQUEST)


@router.get("/users/role/{role}",
            response_model=List[UserShow]|dict,
            status_code=status.HTTP_200_OK,
            summary= "Get users by role",
            description= "AUTHENTICATION required",
            dependencies=[Depends(get_current_user)]
            )
def get_users_by_role(role:str, db:Session=Depends(get_db)):
    try:
        response = get_user_by_role(db=db,role=role)

        return response
    except:
        raise HTTPException(detail="something went wrong", status_code=status.HTTP_400_BAD_REQUEST)


@router.get("/users/name/{name}", 
            response_model=UserShow|dict,
            status_code=status.HTTP_200_OK,
            summary = "Get user by name",
            description= "AUTHENTICATION required",
            dependencies=[Depends(get_current_user)])
def get_user_by_name(name:str, db:Session=Depends(get_db)):
    try:
        response = get_user(name=name,db=db)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)


@router.get("/users/promotion/{promotion}",
            response_model=List[UserShow]|dict, 
            status_code=status.HTTP_200_OK,
            summary = "Get users by promotion",
            description= "AUTHENTICATION required",
            dependencies=[Depends(get_current_user)])
def get_users_by_promotion(promotion:str, db:Session=Depends(get_db)):
    try:
        response = get_user_by_promotion(db=db,promotion=promotion)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)  
    

@router.post("/users",
             response_model = dict,
             status_code = status.HTTP_201_CREATED,
             summary = "Add a new user",
             description = " ADMIN : required\t\nAUTHENTICATION : required")
def create_user(user:UserCreate, db:Session=Depends(get_db), current_user:User=Depends(get_current_user)) -> dict:
    try:
        response = create_new_user(user=user, db=db, current_user=current_user)
        return response
    except:
        raise HTTPException(detail = "database error", status_code = status.HTTP_400_BAD_REQUEST)
    

@router.put("/users/update_deposit/{name}",
            response_model=dict,
            status_code = status.HTTP_200_OK,
            summary = "Update deposit of user:name ",
            description = " ADMIN : required\t\nAUTHENTICATION : required")
def update_deposit(name:str,new_deposit:float,db:Session=Depends(get_db),current_user:User=Depends(get_current_user)):
    try:
        user = get_user(name=name,db=db)
        response = update_user_deposit(db=db,user=user,deposit=new_deposit,current_user=current_user)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)


@router.delete("/users/delete/{name}",
               status_code=status.HTTP_200_OK,
               response_model=dict,
               summary = "Delete user by name ",
               description = " ADMIN : required\t\nAUTHENTICATION : required")
def delete_user_by_name(name:str, db:Session=Depends(get_db), current_user:User=Depends(get_current_user)):
    try:
        response = delete_user(name=name,db=db,current_user=current_user)
        return response
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)


@router.post("/token",response_model=Token,
             status_code=status.HTTP_200_OK,
             summary="authentication token")
def login_token(form_data:OAuth2PasswordRequestForm=Depends(), db:Session=Depends(get_db)):
    user = authenticate_user(form_data.username, form_data.password,db)
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,detail="incorrect username or password")
    access_token = create_access_token(data={"sub": user.name})
    return {"access_token": access_token, "token_type": "bearer"}




