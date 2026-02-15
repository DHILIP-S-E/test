from typing import List
from app.repositories.tasks_repository import TasksRepository
from app.schemas.tasks import TaskCreate, ProjectCreate, ExecutionCreate, Task, Project, Execution

class TasksService:
    def __init__(self, tasks_repository: TasksRepository):
        self.tasks_repository = tasks_repository

    def create_project(self, user_id: str, project_in: ProjectCreate) -> Project:
        return self.tasks_repository.create_project(user_id, project_in)

    def get_user_projects(self, user_id: str) -> List[Project]:
        return self.tasks_repository.get_projects(user_id)

    def create_task(self, user_id: str, task_in: TaskCreate) -> Task:
        return self.tasks_repository.create_task(user_id, task_in)

    def get_user_tasks(self, user_id: str, skip: int = 0, limit: int = 100) -> List[Task]:
        return self.tasks_repository.get_tasks(user_id, skip, limit)

    def start_execution(self, user_id: str, execution_in: ExecutionCreate) -> Execution:
        return self.tasks_repository.create_execution(user_id, execution_in)
