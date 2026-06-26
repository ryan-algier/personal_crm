-- ============================================================
-- Run this in MySQL Workbench before running import_to_mysql.py
--
-- Usage:
--   1. Open MySQL Workbench
--   2. Connect to your local MySQL instance
--   3. Open this file and run it (lightning bolt icon or Ctrl+Shift+Enter)
-- ============================================================
USE networking_crm_sample;

ALTER TABLE interactions
ADD COLUMN thank_you_required boolean DEFAULT FALSE;
