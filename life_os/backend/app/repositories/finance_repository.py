from typing import List, Optional
from sqlalchemy.orm import Session
from app.models.finance import Transaction, Budget, Goal
from app.schemas.finance import TransactionCreate, BudgetCreate, GoalCreate

class FinanceRepository:
    def __init__(self, db: Session):
        self.db = db

    # --- Transactions ---
    def create_transaction(self, user_id: str, transaction_in: TransactionCreate) -> Transaction:
        db_obj = Transaction(**transaction_in.model_dump(), user_id=user_id)
        self.db.add(db_obj)
        self.db.commit()
        self.db.refresh(db_obj)
        return db_obj

    def get_transactions(self, user_id: str, skip: int = 0, limit: int = 100) -> List[Transaction]:
        return self.db.query(Transaction).filter(Transaction.user_id == user_id).offset(skip).limit(limit).all()

    # --- Budgets ---
    def create_budget(self, user_id: str, budget_in: BudgetCreate) -> Budget:
        db_obj = Budget(**budget_in.model_dump(), user_id=user_id)
        self.db.add(db_obj)
        self.db.commit()
        self.db.refresh(db_obj)
        return db_obj

    def get_budgets(self, user_id: str) -> List[Budget]:
        return self.db.query(Budget).filter(Budget.user_id == user_id).all()

    # --- Goals ---
    def create_goal(self, user_id: str, goal_in: GoalCreate) -> Goal:
        db_obj = Goal(**goal_in.model_dump(), user_id=user_id)
        self.db.add(db_obj)
        self.db.commit()
        self.db.refresh(db_obj)
        return db_obj

    def get_goals(self, user_id: str) -> List[Goal]:
        return self.db.query(Goal).filter(Goal.user_id == user_id).all()
