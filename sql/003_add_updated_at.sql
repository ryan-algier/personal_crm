-- ============================================================
-- 003_add_updated_at.sql
-- Adds updated_at timestamp to contacts, companies, and interactions
-- MySQL updates this column automatically on every row change
--
-- Run in MySQL Workbench after 002_add_thank_you_required.sql
-- ============================================================

USE personal_crm;

ALTER TABLE companies
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE contacts
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE interactions
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
