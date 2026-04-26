from db import execute, fetch_all, get_connection


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


def list_vendors():
    return fetch_all(
        """
        SELECT VendorID, VendorName
        FROM Vendors
        ORDER BY VendorName
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


def add_equipment_with_purchase(
    name,
    equipment_type,
    unit,
    department_id,
    vendor_id,
    purchase_date,
    purchase_value,
):
    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            """
            INSERT INTO Equipment (EquipmentName, Type, Unit, DepartmentID)
            VALUES (%s, %s, %s, %s)
            """,
            (name, equipment_type, unit, department_id),
        )
        equipment_id = cursor.lastrowid

        cursor.execute(
            """
            INSERT INTO Purchases (EquipmentID, VendorID, PurchaseDate, Value)
            VALUES (%s, %s, %s, %s)
            """,
            (equipment_id, vendor_id, purchase_date, purchase_value),
        )
        conn.commit()
        return equipment_id
    except Exception:
        conn.rollback()
        raise
    finally:
        cursor.close()
        conn.close()


def update_equipment_status(equipment_id, status):
    execute(
        "UPDATE Equipment SET Status = %s WHERE EquipmentID = %s",
        (status, equipment_id),
    )
