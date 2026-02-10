-- SIMPLIFIA Pack WhatsApp - SQLite Schema (MVP)
-- Version: 1.0.0
-- Tabelas: interactions, followups (simplificado)

-- Interactions table (logs de todas as interações)
CREATE TABLE IF NOT EXISTS interactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    name TEXT,
    pack_id TEXT NOT NULL DEFAULT 'whatsapp',
    workflow_id TEXT,
    direction TEXT NOT NULL, -- inbound, outbound
    message_preview TEXT,
    intent TEXT, -- orcamento, agendamento, duvida, reclamacao, elogio
    intent_confidence REAL,
    status TEXT DEFAULT 'pending', -- pending, processed, sent, failed
    draft_response TEXT,
    final_response TEXT,
    metadata TEXT, -- JSON para dados extras
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Follow-ups table (lembretes e sequências)
CREATE TABLE IF NOT EXISTS followups (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    name TEXT,
    type TEXT NOT NULL, -- pos_venda_d1, pos_venda_d7, pos_venda_d30, lembrete, reengajamento
    scheduled_for TEXT NOT NULL,
    status TEXT DEFAULT 'pending', -- pending, sent, cancelled
    message_template TEXT,
    sent_at TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Indexes para performance
CREATE INDEX IF NOT EXISTS idx_interactions_created ON interactions(created_at);
CREATE INDEX IF NOT EXISTS idx_interactions_phone ON interactions(phone);
CREATE INDEX IF NOT EXISTS idx_interactions_intent ON interactions(intent);
CREATE INDEX IF NOT EXISTS idx_followups_scheduled ON followups(scheduled_for);
CREATE INDEX IF NOT EXISTS idx_followups_status ON followups(status);
