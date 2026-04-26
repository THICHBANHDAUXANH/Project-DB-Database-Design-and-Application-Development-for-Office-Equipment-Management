from db import execute, fetch_all


def list_maintenance():
    return fetch_all(
        """
        SELECT m.MaintenanceID, e.EquipmentName, m.MaintenanceDate, m.Description, m.Cost, m.Status
        FROM Maintenance m
        JOIN Equipment e ON m.EquipmentID = e.EquipmentID
        ORDER BY m.MaintenanceDate
        """
    )


def add_maintenance(equipment_id, maintenance_date, description, cost):
    execute(
        "CALL AddMaintenance(%s, %s, %s, %s)",
        (equipment_id, maintenance_date, description, cost),
    )


def complete_maintenance(maintenance_id):
    execute(
        "UPDATE Maintenance SET Status = 'Completed' WHERE MaintenanceID = %s",
        (maintenance_id,),
    )
