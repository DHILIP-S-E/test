from typing import Optional, List
from pydantic import BaseModel, UUID4
from datetime import date, datetime, time, timedelta

# --- Project Schemas ---
class ProjectBase(BaseModel):
    name: str
    description: Optional[str] = None
    color: Optional[str] = '#F59E0B'
    icon: Optional[str] = None
    is_archived: Optional[bool] = False
    display_order: Optional[int] = 0

class ProjectCreate(ProjectBase):
    pass

class Project(ProjectBase):
    id: UUID4
    user_id: UUID4
    created_at: datetime

    class Config:
        from_attributes = True

# --- Task Schemas ---
class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    scheduled_date: Optional[date] = None
    scheduled_time: Optional[time] = None
    priority: Optional[int] = 0
    project_id: Optional[UUID4] = None
    status: Optional[str] = 'pending'
    reminder_enabled: Optional[bool] = False
    reminder_time: Optional[datetime] = None
    tags: Optional[List[str]] = []
    linked_expense_id: Optional[UUID4] = None

class TaskCreate(TaskBase):
    pass

class Task(TaskBase):
    id: UUID4
    user_id: UUID4
    completed_at: Optional[datetime] = None
    created_at: datetime

    class Config:
        from_attributes = True

# --- Execution Schemas ---
class ExecutionBase(BaseModel):
    task_id: UUID4
    start_time: datetime
    status: Optional[str] = 'active'
    notes: Optional[str] = None

class ExecutionCreate(ExecutionBase):
    pass

class Execution(ExecutionBase):
    id: UUID4
    user_id: UUID4
    end_time: Optional[datetime] = None
    active_duration: Optional[timedelta] = None
    pause_count: Optional[int] = 0
    created_at: datetime

    class Config:
        from_attributes = True
