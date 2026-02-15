from typing import Optional, List
from pydantic import BaseModel, UUID4
from datetime import date, datetime

# --- Transaction Schemas ---
class TransactionBase(BaseModel):
    amount: int
    type: str  # 'expense', 'income'
    category: str
    description: Optional[str] = None
    transaction_date: date
    payment_method: Optional[str] = None
    tags: Optional[List[str]] = []
    input_method: Optional[str] = 'manual'

class TransactionCreate(TransactionBase):
    pass

class TransactionUpdate(TransactionBase):
    pass

class Transaction(TransactionBase):
    id: UUID4
    user_id: UUID4
    created_at: datetime

    class Config:
        from_attributes = True

# --- Budget Schemas ---
class BudgetBase(BaseModel):
    category: str
    amount: int
    month: date
    alert_threshold: Optional[int] = 80

class BudgetCreate(BudgetBase):
    pass

class Budget(BudgetBase):
    id: UUID4
    user_id: UUID4
    created_at: datetime

    class Config:
        from_attributes = True

# --- Goal Schemas ---
class GoalBase(BaseModel):
    title: str
    goal_type: str
    target_amount: int
    current_amount: Optional[int] = 0
    target_date: Optional[date] = None
    status: Optional[str] = 'active'
    icon: Optional[str] = None
    color: Optional[str] = None

class GoalCreate(GoalBase):
    pass

class Goal(GoalBase):
    id: UUID4
    user_id: UUID4
    created_at: datetime

    class Config:
        from_attributes = True
