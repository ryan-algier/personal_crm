-- Migration 001: Create initial tables
-- networking_crm schema

USE personal_crm;


-- Companies
CREATE TABLE companies (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    industry    VARCHAR(100),
    size        ENUM ('1-10', '11-50', '51-200', '201-500', '500+', 'unkown') DEFAULT 'unknown',
    website     VARCHAR(255),
    status      VARCHAR(50),
    notes       TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Contacts
CREATE TABLE contacts (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    company_id      INT,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(255),
    phone           VARCHAR(50),
    location        VARCHAR(50),
    linkedin_url    VARCHAR(255),
    how_we_met      ENUM('Family', 'LinkedIn', 'Referral', 'Cold Outreach', 'Career Fair'),
    met_on          DATE,
    outreach_status VARCHAR(50),
    last_contact    DATE,
    follow_up_date  DATE,
    notes           TEXT,
    tags            VARCHAR(255),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_contact_company
        FOREIGN KEY (company_id) REFERENCES companies(id)
        ON DELETE SET NULL
);


-- Interactions
CREATE TABLE interactions (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    contact_id  INT NOT NULL,
    interaction_date DATE,
    interaction_type VARCHAR(50),
    summary     TEXT,
    outcome     TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_interaction_contact
        FOREIGN KEY (contact_id) REFERENCES contacts(id)
        ON DELETE CASCADE
);



-- referrals
CREATE TABLE referrals (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    referrer_id     INT NOT NULL,
    referred_id     INT NOT NULL,
    date            DATE,
    notes           TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_referral_referrer
        FOREIGN KEY (referrer_id) REFERENCES contacts(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_referral_referred
        FOREIGN KEY (referred_id) REFERENCES contacts(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_no_self_referral
        CHECK (referrer_id != referred_id)
);