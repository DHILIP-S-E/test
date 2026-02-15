from typing import List, Optional
from sqlalchemy.orm import Session
from app.models.tasks import Task, Project, Execution
from app.schemas.tasks import TaskCreate, ProjectCreate, ExecutionCreate

class TasksRepository:
    def __init__(self, db: Session):
        self.db = db

    # --- Projects ---
    def create_project(self, user_id: str, project_in: ProjectCreate) -> Project:
        db_obj = Project(**project_in.model_dump(), user_id=user_id)
        self.db.add(db_obj)
        self.db.commit()
        self.db.refresh(db_obj)
        return db_obj

    def get_projects(self, user_id: str) -> List[Project]:
        return self.db.query(Project).filter(Project.user_id == user_id).all()

    # --- Tasks ---
    def create_task(self, user_id: str, task_in: TaskCreate) -> Task:
        db_obj = Task(**task_in.model_dump(), user_id=user_id)
        self.db.add(db_obj)
        self.db.commit()
        self.db.refresh(db_obj)
        return db_obj

    def get_tasks(self, user_id: str, skip: int = 0, limit: int = 100) -> List[Task]:
        return self.db.query(Task).filter(Task.user_id == user_id).offset(skip).limit(limit).all()

    # --- Executions ---
    def create_execution(self, user_id: str, execution_in: ExecutionCreate) -> Execution:
        db_obj = Execution(**execution_in.model_dump(), user_id=user_id)
        self.db.add(db_obj)
        self.db.commit()
        self.db.refresh(db_obj)
        return db_obj
