from typing import List, Any
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import models
from app.api import deps
from app.schemas.finance import Transaction, TransactionCreate, Budget, BudgetCreate, Goal, GoalCreate
from app.repositories.finance_repository import FinanceRepository
from app.services.finance_service import FinanceService

router = APIRouter()

# --- Transactions ---

@router.post("/transactions", response_model=Transaction)
def create_transaction(
    *,
    db: Session = Depends(deps.get_db),
    transaction_in: TransactionCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Create a new transaction.
    """
    repo = FinanceRepository(db)
    service = FinanceService(repo)
    return service.record_transaction(current_user.id, transaction_in)

@router.get("/transactions", response_model=List[Transaction])
def read_transactions(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Retrieve transactions.
    """
    repo = FinanceRepository(db)
    service = FinanceService(repo)
    return service.get_user_transactions(current_user.id, skip=skip, limit=limit)

# --- Budgets ---

@router.post("/budgets", response_model=Budget)
def create_budget(
    *,
    db: Session = Depends(deps.get_db),
    budget_in: BudgetCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Create a new budget.
    """
    repo = FinanceRepository(db)
    service = FinanceService(repo)
    return service.create_budget(current_user.id, budget_in)

@router.get("/budgets", response_model=List[Budget])
def read_budgets(
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Retrieve budgets.
    """
    repo = FinanceRepository(db)
    service = FinanceService(repo)
    return service.get_user_budgets(current_user.id)

# --- Goals ---

@router.post("/goals", response_model=Goal)
def create_goal(
    *,
    db: Session = Depends(deps.get_db),
    goal_in: GoalCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Create a new goal.
    """
    repo = FinanceRepository(db)
    service = FinanceService(repo)
    return service.create_goal(current_user.id, goal_in)

@router.get("/goals", response_model=List[Goal])
def read_goals(
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Retrieve goals.
    """
    repo = FinanceRepository(db)
    service = FinanceService(repo)
    return service.get_user_goals(current_user.id)
