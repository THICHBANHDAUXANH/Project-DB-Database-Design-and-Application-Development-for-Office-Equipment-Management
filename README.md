# Office Equipment Management System

Final project for Project 20: Office Equipment Management System.

## Folder Structure

- `sql/`: database creation, table creation, sample data, advanced database objects, and security/backup scripts.
- `python/`: Python modules for database access, CLI utilities, and the Streamlit demo.

## Setup

1. Run SQL scripts in order from `sql/01_create_database.sql` to `sql/05_security_backup.sql`.
2. Install Python dependencies:

```bash
python -m pip install -r requirements.txt
```

3. Update database credentials directly in `python/config.py`.
   Edit the values inside `DB_CONFIG` so they match your MySQL setup, especially:
   - `host`
   - `port`
   - `user`
   - `password`
   - `database`

Example:

```python
DB_CONFIG = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "your_mysql_password",
    "database": "office_equipment_management",
}
```

4. Run the CLI application:

```bash
python python/main.py
```

5. Run the Streamlit demo:

```bash
python -m streamlit run python/app.py
```
