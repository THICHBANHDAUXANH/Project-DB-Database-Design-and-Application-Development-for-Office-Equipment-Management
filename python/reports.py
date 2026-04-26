from db import fetch_all, fetch_one


def current_equipment_usage():
    return fetch_all("SELECT * FROM CurrentEquipmentUsage")


def maintenance_cost_report():
    return fetch_all("SELECT * FROM MaintenanceCostReport")


def total_asset_value():
    rows = fetch_all("SELECT TotalAsset() AS TotalValue")
    return rows[0]["TotalValue"] if rows else 0


def dashboard_summary():
    return {
        "total_equipment": fetch_one("SELECT COUNT(*) AS value FROM Equipment")["value"],
        "total_departments": fetch_one("SELECT COUNT(*) AS value FROM Departments")["value"],
        "total_maintenance": fetch_one("SELECT COUNT(*) AS value FROM Maintenance")["value"],
        "total_asset_value": total_asset_value(),
    }
