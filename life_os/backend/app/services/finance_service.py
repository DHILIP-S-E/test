from typing import List
from app.repositories.finance_repository import FinanceRepository
from app.schemas.finance import TransactionCreate, BudgetCreate, GoalCreate, Transaction, Budget, Goal

class FinanceService:
    def __init__(self, finance_repository: FinanceRepository):
        self.finance_repository = finance_repository

    def record_transaction(self, user_id: str, transaction_in: TransactionCreate) -> Transaction:
        # TODO: Implement budget check logic here
        # 1. Check if expense category has a budget
        # 2. Calculate current spending for month
        # 3. Check against alert threshold
        # 4. Trigger alert if needed (via NotificationService - to be implemented)
        return self.finance_repository.create_transaction(user_id, transaction_in)

    def get_user_transactions(self, user_id: str, skip: int = 0, limit: int = 100) -> List[Transaction]:
        return self.finance_repository.get_transactions(user_id, skip, limit)

    def create_budget(self, user_id: str, budget_in: BudgetCreate) -> Budget:
        return self.finance_repository.create_budget(user_id, budget_in)

    def get_user_budgets(self, user_id: str) -> List[Budget]:
        return self.finance_repository.get_budgets(user_id)

    def create_goal(self, user_id: str, goal_in: GoalCreate) -> Goal:
        return self.finance_repository.create_goal(user_id, goal_in)

    def get_user_goals(self, user_id: str) -> List[Goal]:
        return self.finance_repository.get_goals(user_id)
