"""
db.py

Database connection helper for the Flask CRM app.
Loads credentials from .env at the project root.

Usage:
    from db import get_db, close_db
"""

import os
import mysql.connector
from pathlib import Path
from dotenv import load_dotenv

# Load .env from project root (one level above /python)
load_dotenv(Path(__file__).parent.parent / ".env")
mode = os.getenv("DB_MODE", "real")
db_name = os.getenv("DB_NAME_REAL") if mode == "real" else os.getenv("DB_NAME_SAMPLE")

def get_db():
    """Open and return a MySQL connection using credentials from .env."""
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", ""),
        database=db_name,
    )


def close_db(conn, cursor=None):
    """Close cursor and connection safely."""
    if cursor:
        cursor.close()
    if conn:
        conn.close()
