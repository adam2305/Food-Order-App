from fastapi import APIRouter,HTTPException, status, Depends, File, UploadFile
import os
import shutil

from sql_app.models.auth_model import User
from services.security import get_current_user

router = APIRouter()

@router.post("/upload/",
            status_code=status.HTTP_200_OK,
            summary= "upload file [image]",
            description= "AUTHENTICATION required")
async def upload_image(file: UploadFile,current_user:User=Depends(get_current_user)):
    file.file.seek(0, 2)
    file_size = file.file.tell()

    if file_size > 2 * 1024 * 1024: # 2MB
        raise HTTPException(status_code=400, detail="File too large")
    
    content_type = file.content_type #test de l'extension
    if content_type not in ["image/jpeg", "image/png", "image/gif", "image/svg+xml", "image/jpg"]:
        raise HTTPException(status_code=400, detail="Invalid file type")
    
    #sauvegarder le fichier
    upload_dir = os.path.join(os.getcwd(), "static")
    dest = os.path.join(upload_dir, file.filename)
    print(dest)
    with open(dest, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    return {"filename": file.filename}



