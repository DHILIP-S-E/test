from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Date, Time, Interval, ARRAY
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.sql import func
import uuid

from app.db.base_class import Base

class Project(Base):
    __tablename__ = "projects"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    name = Column(String, nullable=False)
    description = Column(String)
    color = Column(String, default='#F59E0B')
    icon = Column(String)
    is_archived = Column(Boolean, default=False)
    display_order = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), default=func.now())

class Task(Base):
    __tablename__ = "tasks"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    title = Column(String, nullable=False)
    description = Column(String)
    scheduled_date = Column(Date)
    scheduled_time = Column(Time)
    priority = Column(Integer, default=0)
    project_id = Column(UUID(as_uuid=True), ForeignKey("projects.id", ondelete="SET NULL"))
    status = Column(String, default='pending')
    reminder_enabled = Column(Boolean, default=False)
    reminder_time = Column(DateTime(timezone=True))
    tags = Column(ARRAY(String))

    linked_expense_id = Column(UUID(as_uuid=True), ForeignKey("transactions.id", ondelete="SET NULL"))

    completed_at = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), default=func.now())

class Execution(Base):
    __tablename__ = "executions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    task_id = Column(UUID(as_uuid=True), ForeignKey("tasks.id", ondelete="CASCADE"))
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    start_time = Column(DateTime(timezone=True), nullable=False)
    end_time = Column(DateTime(timezone=True))
    status = Column(String, default='active')
    active_duration = Column(Interval)
    pause_count = Column(Integer, default=0)
    notes = Column(String)
    created_at = Column(DateTime(timezone=True), default=func.now())
