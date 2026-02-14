from typing import Optional
from sqlalchemy.orm import Session
from app.repositories.user_repository import UserRepository
from app.schemas.user import UserCreate
from app.models.user import User
from app.core import security

class AuthService:
    def __init__(self, user_repository: UserRepository):
        self.user_repository = user_repository

    def authenticate(self, email: str, password: str) -> Optional[User]:
        user = self.user_repository.get_by_email(email)
        if not user:
            return None
        if not security.verify_password(password, user.hashed_password):
            return None
        return user

    def register_user(self, user_in: UserCreate) -> User:
        existing_user = self.user_repository.get_by_email(user_in.email)
        if existing_user:
            raise ValueError("The user with this email already exists in the system")
        return self.user_repository.create(user_in)
