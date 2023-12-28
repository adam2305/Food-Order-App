## CODE VERIFIED

from datetime import date
from pydantic import BaseModel, EmailStr, constr
from typing import Annotated, Literal, Any


class UserCreate(BaseModel):
    name : Annotated[str,constr(strip_whitespace=True, 
                                max_length=40,
                                to_lower=True)]
    email : EmailStr
    password : Annotated[str,constr(max_length=40)]
    role : Literal['ADMIN','COTISANT','BUREAU','SERVEUR','STOCK'] = 'COTISANT'
    promotion : Annotated[str,constr(strip_whitespace=True, 
                                    max_length=20,
                                    to_lower=True)] = "EI22"

class UserShow(BaseModel):
    name : Annotated[str,constr(strip_whitespace=True, 
                                max_length=40,
                                to_lower=True)]
    email : EmailStr
    role : Any
    promotion : Annotated[str,constr(strip_whitespace=True, 
                                    max_length=20,
                                    to_lower=True)]
    creation_date : date
    deposit:float

