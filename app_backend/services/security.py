from datetime import datetime, timedelta
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer 
from jose import jwt, JWTError
from passlib.context import CryptContext
from sqlalchemy.orm import Session
from typing import Optional

from config import settings
from sql_app.models.auth_model import User
from sql_app.database import get_db


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
class Hasher():
    @staticmethod
    def verify_password(plain_password, hashed_password) -> CryptContext:
        return pwd_context.verify(plain_password, hashed_password)

    @staticmethod
    def get_password_hash(password) -> CryptContext:
        return pwd_context.hash(password)


def create_access_token(data: dict, expires_delta:Optional[timedelta]=None) -> str:
    to_encode = data.copy()
    ACCESS_TOKEN_EXPIRE_MINUTES =30
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=int(settings.ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt


def get_user(name:str,db: Session) -> User|None:
    user = db.query(User).filter(User.name == name).first()
    if user:
        return user
    return dict(detail="no users found", status_code=status.HTTP_200_OK)

def authenticate_user(name:str, password:str, db:Session) -> User:
    user = get_user(name=name,db=db)
    if not user:
        return False
    if not Hasher.verify_password(password, user.password):
        return False
    return user


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/token")
def get_current_user(token: str = Depends(oauth2_scheme), db:Session=Depends(get_db)) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials")
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    user = get_user(name=username, db=db)
    if user is None:
        raise credentials_exception
    return user