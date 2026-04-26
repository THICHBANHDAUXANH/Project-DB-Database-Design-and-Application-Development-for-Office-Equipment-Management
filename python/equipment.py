from db import execute, fetch_all


def list_equipment():
    return fetch_all(
        """
        SELECT EquipmentID, EquipmentName, Type, Status, ConditionStatus
        FROM Equipment
        ORDER BY EquipmentID
        """
    )


def equipment_options():
    return fetch_all(
        """
        SELECT EquipmentID, EquipmentName
        FROM Equipment
        ORDER BY EquipmentName
        """
    )


def list_departments():
    return fetch_all(
        """
        SELECT DepartmentID, DepartmentName
        FROM Departments
        ORDER BY DepartmentName
        """
    )


def add_equipment(name, equipment_type, unit, department_id):
    execute(
        """
        INSERT INTO Equipment (EquipmentName, Type, Unit, DepartmentID)
        VALUES (%s, %s, %s, %s)
        """,
        (name, equipment_type, unit, department_id),
    )


def update_equipment_status(equipment_id, status):
    execute(
        "UPDATE Equipment SET Status = %s WHERE EquipmentID = %s",
        (status, equipment_id),
    )
