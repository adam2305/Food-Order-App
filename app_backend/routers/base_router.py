from fastapi import APIRouter

from routers import auth_route,product_route,order_route,static_route

api_router = APIRouter()
api_router.include_router(auth_route.router,prefix="",tags=["users"])
api_router.include_router(product_route.router,prefix="",tags=["products"])
api_router.include_router(order_route.router,prefix="",tags=["orders"])
api_router.include_router(static_route.router,prefix="",tags=["upload"])


@api_router.get("/")
async def root():
    return {"message": "Comif API==1.0.0"}