from pydantic import BaseModel, Field, conint, constr
from typing import Annotated, Literal


class OrderCreate(BaseModel):
    product : Annotated[str,constr(strip_whitespace=True, 
                                        max_length=40)]
    command_quantity : Annotated[int,conint(lt=999)]

