from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
import uuid

from app.db.base_class import Base

class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String, unique=True, index=True, nullable=False)
    phone = Column(String, unique=True, index=True)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String)
    avatar_url = Column(String)
    timezone = Column(String, default='Asia/Kolkata')
    language_preference = Column(String, default='en')

    is_active = Column(Boolean, default=True)
    is_superuser = Column(Boolean, default=False)

    finance_module_enabled = Column(Boolean, default=True)
    tasks_module_enabled = Column(Boolean, default=True)

    is_premium = Column(Boolean, default=False)
    premium_expires_at = Column(DateTime(timezone=True))

    created_at = Column(DateTime(timezone=True), default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
