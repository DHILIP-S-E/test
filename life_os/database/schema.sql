-- LifeOS Database Schema
-- Version: 1.0 Final
-- Date: February 2026

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- [SHARED] Core Tables (5 tables)
-- ============================================================================

-- 1. users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  phone TEXT UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  timezone TEXT DEFAULT 'Asia/Kolkata',
  language_preference TEXT DEFAULT 'en',

  -- Module activation
  finance_module_enabled BOOLEAN DEFAULT TRUE,
  tasks_module_enabled BOOLEAN DEFAULT TRUE,

  -- Premium (UNIFIED for both modules)
  is_premium BOOLEAN DEFAULT FALSE,
  premium_expires_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. user_settings
CREATE TABLE user_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  theme TEXT DEFAULT 'light',
  notifications_enabled BOOLEAN DEFAULT TRUE,

  -- Module-specific settings
  finance_settings JSONB DEFAULT '{}',
  tasks_settings JSONB DEFAULT '{}',

  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- 3. subscriptions
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  plan_type TEXT NOT NULL, -- 'monthly', 'yearly'
  status TEXT NOT NULL, -- 'active', 'cancelled'
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ NOT NULL,
  amount INTEGER NOT NULL,
  payment_provider TEXT DEFAULT 'razorpay',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- [TASKS MODULE] Tables (12 tables) - Created before Finance due to FK dependencies
-- ============================================================================

-- 4. projects
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  color TEXT DEFAULT '#F59E0B', -- Orange (Tasks accent)
  icon TEXT,
  is_archived BOOLEAN DEFAULT FALSE,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. tasks
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  scheduled_date DATE,
  scheduled_time TIME,
  priority INTEGER DEFAULT 0, -- 0=none, 1=low, 2=medium, 3=high
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
  status TEXT DEFAULT 'pending',
  reminder_enabled BOOLEAN DEFAULT FALSE,
  reminder_time TIMESTAMPTZ,
  tags TEXT[],

  -- Cross-module link (linked_expense_id will be added later due to circular dependency)
  linked_expense_id UUID,

  calendar_event_id TEXT,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_tasks_user_date ON tasks(user_id, scheduled_date);

-- 6. executions
CREATE TABLE executions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ,
  status TEXT DEFAULT 'active',
  active_duration INTERVAL,
  pause_count INTEGER DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. execution_events
CREATE TABLE execution_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  execution_id UUID REFERENCES executions(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL, -- 'start', 'pause', 'resume', 'end'
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT
);

-- 8. alarms
CREATE TABLE alarms (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  scheduled_time TIMESTAMPTZ NOT NULL,
  status TEXT DEFAULT 'pending',
  fired_at TIMESTAMPTZ,
  snoozed_until TIMESTAMPTZ,
  dismissed_at TIMESTAMPTZ,
  notification_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. sync_queue
CREATE TABLE sync_queue (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  operation_type TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  payload JSONB NOT NULL,
  retry_count INTEGER DEFAULT 0,
  synced_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. task_templates
CREATE TABLE task_templates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  template_data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 11. recurring_tasks
CREATE TABLE recurring_tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT,
  frequency TEXT, -- 'daily', 'weekly', 'monthly'
  template_data JSONB,
  is_active BOOLEAN DEFAULT TRUE
);

-- 12. task_comments
CREATE TABLE task_comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  comment_text TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 13. task_attachments
CREATE TABLE task_attachments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  file_url TEXT,
  file_name TEXT,
  file_type TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 14. calendar_syncs
CREATE TABLE calendar_syncs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  provider TEXT, -- 'google', 'apple'
  access_token TEXT,
  refresh_token TEXT,
  last_sync_at TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT TRUE
);

-- 15. integrations
CREATE TABLE integrations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  integration_type TEXT,
  config JSONB,
  is_active BOOLEAN DEFAULT TRUE
);


-- ============================================================================
-- [FINANCE MODULE] Tables (18 tables)
-- ============================================================================

-- 16. transactions
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL, -- paise
  type TEXT NOT NULL, -- 'expense', 'income'
  category TEXT NOT NULL,
  description TEXT,
  transaction_date DATE NOT NULL,
  payment_method TEXT,
  receipt_url TEXT,
  tags TEXT[],

  -- Cross-module link
  linked_task_id UUID REFERENCES tasks(id) ON DELETE SET NULL,

  input_method TEXT, -- 'voice', 'photo', 'chat', 'manual'
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_transactions_user_date ON transactions(user_id, transaction_date);
CREATE INDEX idx_transactions_linked_task ON transactions(linked_task_id);

-- Add the missing FK to tasks
ALTER TABLE tasks ADD CONSTRAINT fk_tasks_linked_expense FOREIGN KEY (linked_expense_id) REFERENCES transactions(id) ON DELETE SET NULL;
CREATE INDEX idx_tasks_linked_expense ON tasks(linked_expense_id);


-- 17. goals
CREATE TABLE goals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  goal_type TEXT NOT NULL, -- 'savings', 'debt_payoff', 'investment'
  target_amount INTEGER NOT NULL,
  current_amount INTEGER DEFAULT 0,
  target_date DATE,
  status TEXT DEFAULT 'active',
  icon TEXT,
  color TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 18. goal_transactions
CREATE TABLE goal_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  goal_id UUID REFERENCES goals(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  transaction_date DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 19. budgets
CREATE TABLE budgets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  category TEXT NOT NULL,
  amount INTEGER NOT NULL,
  month DATE NOT NULL,
  alert_threshold INTEGER DEFAULT 80,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, category, month)
);

-- 20. achievements
CREATE TABLE achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  unlock_condition JSONB NOT NULL,
  points INTEGER DEFAULT 100,
  rarity TEXT DEFAULT 'common'
);

-- 21. user_achievements
CREATE TABLE user_achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  achievement_id UUID REFERENCES achievements(id) ON DELETE CASCADE,
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, achievement_id)
);

-- 22. challenges
CREATE TABLE challenges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  challenge_type TEXT NOT NULL, -- 'daily', 'weekly', 'monthly'
  reward_coins INTEGER,
  start_date DATE,
  end_date DATE,
  is_active BOOLEAN DEFAULT TRUE
);

-- 23. user_challenges
CREATE TABLE user_challenges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'active',
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, challenge_id)
);

-- 24. coins_balance
CREATE TABLE coins_balance (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
  balance INTEGER DEFAULT 0,
  lifetime_earned INTEGER DEFAULT 0,
  lifetime_spent INTEGER DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 25. coins_transactions
CREATE TABLE coins_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  transaction_type TEXT NOT NULL, -- 'earn', 'spend'
  source TEXT NOT NULL,
  balance_after INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 26. education_modules
CREATE TABLE education_modules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  level TEXT NOT NULL, -- 'beginner', 'intermediate', 'advanced'
  duration_minutes INTEGER,
  reward_coins INTEGER,
  display_order INTEGER
);

-- 27. user_education_progress
CREATE TABLE user_education_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  module_id UUID REFERENCES education_modules(id) ON DELETE CASCADE,
  completed_at TIMESTAMPTZ,
  quiz_score INTEGER,
  UNIQUE(user_id, module_id)
);

-- 28. mini_games
CREATE TABLE mini_games (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  game_type TEXT NOT NULL,
  max_score INTEGER,
  reward_coins INTEGER
);

-- 29. game_scores
CREATE TABLE game_scores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  game_id UUID REFERENCES mini_games(id) ON DELETE CASCADE,
  score INTEGER,
  coins_earned INTEGER,
  played_at TIMESTAMPTZ DEFAULT NOW()
);

-- 30. financial_profiles
CREATE TABLE financial_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
  journey_type TEXT, -- 'student', 'professional', 'freelancer'
  income_type TEXT,
  city_type TEXT,
  life_stage TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 31. recurring_transactions
CREATE TABLE recurring_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  template_name TEXT,
  amount INTEGER,
  category TEXT,
  frequency TEXT, -- 'daily', 'weekly', 'monthly'
  is_active BOOLEAN DEFAULT TRUE
);

-- 32. categories
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  icon TEXT,
  color TEXT,
  is_custom BOOLEAN DEFAULT TRUE,
  UNIQUE(user_id, name)
);

-- 33. merchants
CREATE TABLE merchants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  category TEXT,
  logo_url TEXT
);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables that have user_id
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE executions ENABLE ROW LEVEL SECURITY;
ALTER TABLE execution_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE alarms ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE task_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE recurring_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE task_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE task_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE calendar_syncs ENABLE ROW LEVEL SECURITY;
ALTER TABLE integrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE goal_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE coins_balance ENABLE ROW LEVEL SECURITY;
ALTER TABLE coins_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_education_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE recurring_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Create policies (Example for users table, can be replicated for others)
-- In a real Supabase environment, auth.uid() returns the current user's ID.

-- Policy: Users can view their own profile
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Generic policy for user-owned data
-- Since we are running this as a script, we will define a macro or just comments for now
-- as `auth.uid()` is specific to Supabase's environment.
--
-- Example for transactions:
-- CREATE POLICY "User can CRUD own transactions" ON transactions
--   FOR ALL USING (auth.uid() = user_id);
