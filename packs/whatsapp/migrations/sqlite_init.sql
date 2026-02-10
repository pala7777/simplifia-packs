-- SIMPLIFIA Pack WhatsApp - SQLite Schema
-- Version: 1.0.0

-- Customers table
CREATE TABLE IF NOT EXISTS customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT UNIQUE NOT NULL,
    name TEXT,
    first_contact_at TEXT NOT NULL DEFAULT (datetime('now')),
    last_contact_at TEXT NOT NULL DEFAULT (datetime('now')),
    status TEXT DEFAULT 'lead', -- lead, active, inactive, blocked
    tags TEXT, -- JSON array
    notes TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Interactions table (logs)
CREATE TABLE IF NOT EXISTS interactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER REFERENCES customers(id),
    pack_id TEXT NOT NULL DEFAULT 'whatsapp',
    workflow_id TEXT,
    direction TEXT NOT NULL, -- inbound, outbound
    message_preview TEXT,
    intent TEXT, -- orcamento, agendamento, duvida, reclamacao, elogio
    intent_confidence REAL,
    status TEXT DEFAULT 'pending', -- pending, processed, sent, failed
    draft_response TEXT,
    final_response TEXT,
    metadata TEXT, -- JSON
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Follow-ups table
CREATE TABLE IF NOT EXISTS followups (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER REFERENCES customers(id),
    type TEXT NOT NULL, -- pos_venda_d1, pos_venda_d7, pos_venda_d30, reminder
    scheduled_for TEXT NOT NULL,
    status TEXT DEFAULT 'pending', -- pending, sent, cancelled
    message_template TEXT,
    sent_at TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Cases table (for complaints/issues)
CREATE TABLE IF NOT EXISTS cases (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER REFERENCES customers(id),
    interaction_id INTEGER REFERENCES interactions(id),
    type TEXT NOT NULL, -- reclamacao, devolucao, suporte
    priority TEXT DEFAULT 'normal', -- low, normal, high, urgent
    status TEXT DEFAULT 'open', -- open, in_progress, resolved, closed
    description TEXT,
    resolution TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    resolved_at TEXT
);

-- Schedules table (appointments)
CREATE TABLE IF NOT EXISTS schedules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER REFERENCES customers(id),
    service TEXT,
    scheduled_at TEXT NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    status TEXT DEFAULT 'confirmed', -- pending, confirmed, cancelled, done
    reminder_sent INTEGER DEFAULT 0,
    notes TEXT,
    ics_file TEXT, -- path to generated .ics
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_interactions_customer ON interactions(customer_id);
CREATE INDEX IF NOT EXISTS idx_interactions_created ON interactions(created_at);
CREATE INDEX IF NOT EXISTS idx_interactions_intent ON interactions(intent);
CREATE INDEX IF NOT EXISTS idx_followups_scheduled ON followups(scheduled_for);
CREATE INDEX IF NOT EXISTS idx_followups_status ON followups(status);
CREATE INDEX IF NOT EXISTS idx_cases_status ON cases(status);
CREATE INDEX IF NOT EXISTS idx_schedules_date ON schedules(scheduled_at);
