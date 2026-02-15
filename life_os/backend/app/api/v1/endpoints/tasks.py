from typing import List, Any
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import models
from app.api import deps
from app.schemas.tasks import Task, TaskCreate, Project, ProjectCreate, Execution, ExecutionCreate
from app.repositories.tasks_repository import TasksRepository
from app.services.tasks_service import TasksService

router = APIRouter()

# --- Projects ---

@router.post("/projects", response_model=Project)
def create_project(
    *,
    db: Session = Depends(deps.get_db),
    project_in: ProjectCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Create a new project.
    """
    repo = TasksRepository(db)
    service = TasksService(repo)
    return service.create_project(current_user.id, project_in)

@router.get("/projects", response_model=List[Project])
def read_projects(
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Retrieve projects.
    """
    repo = TasksRepository(db)
    service = TasksService(repo)
    return service.get_user_projects(current_user.id)

# --- Tasks ---

@router.post("/tasks", response_model=Task)
def create_task(
    *,
    db: Session = Depends(deps.get_db),
    task_in: TaskCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Create a new task.
    """
    repo = TasksRepository(db)
    service = TasksService(repo)
    return service.create_task(current_user.id, task_in)

@router.get("/tasks", response_model=List[Task])
def read_tasks(
    db: Session = Depends(deps.get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Retrieve tasks.
    """
    repo = TasksRepository(db)
    service = TasksService(repo)
    return service.get_user_tasks(current_user.id, skip=skip, limit=limit)

# --- Executions ---

@router.post("/executions/start", response_model=Execution)
def start_execution(
    *,
    db: Session = Depends(deps.get_db),
    execution_in: ExecutionCreate,
    current_user: models.User = Depends(deps.get_current_active_user),
) -> Any:
    """
    Start task execution (timer).
    """
    repo = TasksRepository(db)
    service = TasksService(repo)
    return service.start_execution(current_user.id, execution_in)
