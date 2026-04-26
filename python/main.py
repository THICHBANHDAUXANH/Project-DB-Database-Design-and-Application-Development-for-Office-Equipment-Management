from equipment import add_equipment, list_equipment, update_equipment_status
from maintenance import add_maintenance, complete_maintenance, list_maintenance
from reports import current_equipment_usage, maintenance_cost_report, total_asset_value


def print_rows(rows):
    if not rows:
        print("No data found.")
        return
    for row in rows:
        print(row)


def menu():
    print("\nOffice Equipment Management System")
    print("1. List equipment")
    print("2. Add equipment")
    print("3. Update equipment status")
    print("4. List maintenance")
    print("5. Add maintenance")
    print("6. Complete maintenance")
    print("7. Current equipment usage report")
    print("8. Maintenance cost report")
    print("9. Total asset value")
    print("0. Exit")


def main():
    while True:
        menu()
        choice = input("Choose an option: ").strip()

        if choice == "1":
            print_rows(list_equipment())
        elif choice == "2":
            name = input("Equipment name: ")
            equipment_type = input("Type: ")
            unit = input("Unit: ")
            department_id = int(input("Department ID: "))
            add_equipment(name, equipment_type, unit, department_id)
            print("Equipment added successfully.")
        elif choice == "3":
            equipment_id = int(input("Equipment ID: "))
            status = input("New status: ")
            update_equipment_status(equipment_id, status)
            print("Status updated successfully.")
        elif choice == "4":
            print_rows(list_maintenance())
        elif choice == "5":
            equipment_id = int(input("Equipment ID: "))
            maintenance_date = input("Maintenance date (YYYY-MM-DD): ")
            description = input("Description: ")
            cost = float(input("Cost: "))
            add_maintenance(equipment_id, maintenance_date, description, cost)
            print("Maintenance schedule added successfully.")
        elif choice == "6":
            maintenance_id = int(input("Maintenance ID: "))
            complete_maintenance(maintenance_id)
            print("Maintenance completed successfully.")
        elif choice == "7":
            print_rows(current_equipment_usage())
        elif choice == "8":
            print_rows(maintenance_cost_report())
        elif choice == "9":
            print(f"Total asset value: {total_asset_value()}")
        elif choice == "0":
            break
        else:
            print("Invalid option.")


if __name__ == "__main__":
    main()
