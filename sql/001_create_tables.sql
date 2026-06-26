-- ============================================================
-- 001_create_tables.sql
-- Networking CRM — Initial Schema
--
-- Run this in MySQL Workbench before running import_to_mysql.py
--
-- Usage:
--   1. Open MySQL Workbench
--   2. Connect to your local MySQL instance
--   3. Open this file and run it (lightning bolt icon or Ctrl+Shift+Enter)
-- ============================================================

CREATE DATABASE IF NOT EXISTS networking_crm_sample;
USE networking_crm_sample;

-- ------------------------------------------------------------
-- Companies
-- A company can exist with no contacts yet
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS companies (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    industry    VARCHAR(100),
    website     VARCHAR(255),
    notes       TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- Contacts
-- A contact may or may not belong to a company (nullable FK)
-- Deleting a company sets company_id to NULL on related contacts
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contacts (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    company_id      INT,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(255),
    phone           VARCHAR(20),
    linkedin_url    VARCHAR(255),
    location        VARCHAR(255),
	how_we_met      ENUM('LinkedIn', 'college', 'life', 'referral', 'cold outreach', 'other'),
    met_on          DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL
);

-- ------------------------------------------------------------
-- Interactions
-- Each touchpoint with a contact
-- Deleting a contact cascades to delete their interactions
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS interactions (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    contact_id  INT NOT NULL,
    date        DATE,
    type        ENUM('email','call','in person', 'LinkedIn', 'thank you', 'other'),
    summary     TEXT,
    outcome     TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Referrals
-- Tracks who referred whom (both FKs point to contacts)
-- Deleting a contact cascades to delete their referral records
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS referrals (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    referrer_id INT NOT NULL,           -- contact who made the referral
    referred_id INT NOT NULL,           -- contact who was referred
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (referrer_id) REFERENCES contacts(id) ON DELETE CASCADE,
    FOREIGN KEY (referred_id) REFERENCES contacts(id) ON DELETE CASCADE,

    CONSTRAINT chk_no_self_referral
        CHECK (referrer_id != referred_id)
);
