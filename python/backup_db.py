"""
backup_db.py

Creates a timestamped MySQL dump of the personal_crm database and saves
it to a 'backups' folder one level above this script.

Backups are kept forever — all files are retained.

Folder structure:
    project/
    ├── backups/
    │   ├── personal_crm_2024_01_15_09_00.sql
    │   ├── personal_crm_2024_01_16_09_00.sql
    │   └── ...
    └── python/
        └── backup_db.py       ← this script

Usage (manual):
    uv run backup_db.py

Usage (automated):
    Set up Windows Task Scheduler to run this script daily.
    See README for Task Scheduler setup instructions.

Requirements:
    - mysqldump must be on your system PATH
    - Credentials loaded from .env at project root
"""

import os
import subprocess
from pathlib import Path
from datetime import datetime
from dotenv import load_dotenv

# ── Paths ─────────────────────────────────────────────────────────────────────

SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent
BACKUP_DIR = PROJECT_ROOT / "backups"

# ── Load credentials ──────────────────────────────────────────────────────────

load_dotenv(PROJECT_ROOT / ".env")

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER", "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")
mode = os.getenv("DB_MODE", "real")
DB_NAME = os.getenv("DB_NAME_REAL") if mode == "real" else os.getenv("DB_NAME_SAMPLE")

# ── Backup ────────────────────────────────────────────────────────────────────

def run_backup():
    # Create backups directory if it doesn't exist
    BACKUP_DIR.mkdir(parents=True, exist_ok=True)

    # Timestamped filename
    timestamp = datetime.now().strftime("%Y_%m_%d_%H_%M")
    filename = f"{DB_NAME}_{timestamp}.sql"
    filepath = BACKUP_DIR / filename

    print(f"Starting backup of '{DB_NAME}'...")
    print(f"Saving to: {filepath}")

    # Build mysqldump command
    # --single-transaction ensures a consistent snapshot without locking tables
    # --routines includes stored procedures if any exist
    command = [
        "mysqldump",
        f"--host={DB_HOST}",
        f"--user={DB_USER}",
        f"--password={DB_PASSWORD}",
        "--single-transaction",
        "--routines",
        DB_NAME,
    ]

    try:
        with open(filepath, "w") as f:
            result = subprocess.run(
                command,
                stdout=f,
                stderr=subprocess.PIPE,
                text=True,
            )

        if result.returncode != 0:
            print(f"ERROR: mysqldump failed:\n{result.stderr}")
            filepath.unlink(missing_ok=True)  # remove empty/partial file
            return False

        size_kb = filepath.stat().st_size / 1024
        print(f"Backup complete. File size: {size_kb:.1f} KB")
        print(f"Total backups stored: {len(list(BACKUP_DIR.glob('*.sql')))}")
        return True

    except FileNotFoundError:
        print("ERROR: mysqldump not found.")
        print("Make sure MySQL is installed and mysqldump is on your system PATH.")
        print("Typical location: C:\\Program Files\\MySQL\\MySQL Server 8.0\\bin")
        print("Add that folder to your Windows PATH environment variable.")
        return False

    except Exception as e:
        print(f"ERROR: {e}")
        filepath.unlink(missing_ok=True)
        return False


def main():
    success = run_backup()
    if not success:
        exit(1)


if __name__ == "__main__":
    main()