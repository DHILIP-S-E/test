from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Date, ARRAY
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
import uuid

from app.db.base_class import Base

class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    amount = Column(Integer, nullable=False)  # paise
    type = Column(String, nullable=False)  # 'expense', 'income'
    category = Column(String, nullable=False)
    description = Column(String)
    transaction_date = Column(Date, nullable=False)
    payment_method = Column(String)
    receipt_url = Column(String)
    tags = Column(ARRAY(String))

    input_method = Column(String)  # 'voice', 'photo', 'chat', 'manual'
    created_at = Column(DateTime(timezone=True), default=func.now())

class Budget(Base):
    __tablename__ = "budgets"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    category = Column(String, nullable=False)
    amount = Column(Integer, nullable=False)
    month = Column(Date, nullable=False)
    alert_threshold = Column(Integer, default=80)
    created_at = Column(DateTime(timezone=True), default=func.now())

class Goal(Base):
    __tablename__ = "goals"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    title = Column(String, nullable=False)
    goal_type = Column(String, nullable=False)  # 'savings', 'debt_payoff', 'investment'
    target_amount = Column(Integer, nullable=False)
    current_amount = Column(Integer, default=0)
    target_date = Column(Date)
    status = Column(String, default='active')
    icon = Column(String)
    color = Column(String)
    created_at = Column(DateTime(timezone=True), default=func.now())
