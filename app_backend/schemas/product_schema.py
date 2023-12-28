from pydantic import BaseModel, constr, confloat
from typing import Annotated, Literal, Any

class ProductShow(BaseModel):
    product: Annotated[str, constr(strip_whitespace=True, 
                                        max_length=40)]
    category:str|Any
    image:Annotated[str, constr(strip_whitespace=True, 
                                        max_length=50)]
    description:Annotated[str, constr(strip_whitespace=True, 
                                        max_length=100)]
    nutrition:Annotated[str, constr(strip_whitespace=True, 
                                        max_length=50)]
    buy_price:Annotated[float,confloat(lt=999)]
    sell_price:Annotated[float,confloat(lt=999)]

class ProductCreate(ProductShow):
    product : Annotated[str, constr(strip_whitespace=True, 
                                        max_length=40)]
    image : Annotated[str, constr(strip_whitespace=True, 
                                        max_length=50)]
    category : Literal['VINS','SOFTS','BIERES','APERITIFS','VIENN']
    description : Annotated[str, constr(strip_whitespace=True, 
                                        max_length=100)]
    nutrition : Annotated[str, constr(strip_whitespace=True, 
                                        max_length=50)]
    buy_price : Annotated[float,confloat(lt=999)]
    sell_price : Annotated[float,confloat(lt=999)]