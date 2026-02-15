from fastapi import APIRouter
from app.api.v1.endpoints import auth, finance, tasks

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(finance.router, prefix="/finance", tags=["finance"])
api_router.include_router(tasks.router, prefix="/tasks", tags=["tasks"])
