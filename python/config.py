import os


DB_CONFIG = {
    "host": os.getenv("OEM_DB_HOST", "localhost"),
    "port": int(os.getenv("OEM_DB_PORT", "3306")),
    "user": os.getenv("OEM_DB_USER", "root"),
    "password": os.getenv("OEM_DB_PASSWORD", ""),
    "database": os.getenv("OEM_DB_NAME", "office_equipment_management"),
}
