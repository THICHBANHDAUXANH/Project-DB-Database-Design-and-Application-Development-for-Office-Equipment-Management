import pandas as pd
import streamlit as st

from equipment import (
    add_equipment_with_purchase,
    equipment_options,
    list_departments,
    list_equipment,
    list_vendors,
)
from maintenance import add_maintenance, complete_maintenance, list_maintenance
from reports import (
    current_equipment_usage,
    dashboard_summary,
    maintenance_cost_report,
    total_asset_value,
)


st.set_page_config(
    page_title="Office Equipment Management",
    page_icon="O",
    layout="wide",
)

st.markdown(
    """
    <style>
    .simple-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }
    .simple-table th, .simple-table td {
        border: 1px solid #d1d5db;
        padding: 8px 10px;
        text-align: left;
    }
    .simple-table th {
        background-color: #f3f4f6;
        font-weight: 600;
    }
    </style>
    """,
    unsafe_allow_html=True,
)


def to_dataframe(rows):
    return pd.DataFrame(rows) if rows else pd.DataFrame()


def render_table(rows):
    df = to_dataframe(rows)
    if df.empty:
        st.info("No data available.")
        return
    st.markdown(
        df.to_html(index=False, classes="simple-table"),
        unsafe_allow_html=True,
    )


def render_dashboard():
    st.title("Office Equipment Management System")
    st.caption("Streamlit demo for database operations and reporting")

    summary = dashboard_summary()
    col1, col2, col3, col4 = st.columns(4)
    col1.metric("Total Equipment", summary["total_equipment"])
    col2.metric("Departments", summary["total_departments"])
    col3.metric("Maintenance Records", summary["total_maintenance"])
    col4.metric("Total Asset Value", f"{summary['total_asset_value']:,.0f}")

    st.subheader("Current Equipment Usage")
    render_table(current_equipment_usage())


def render_equipment_page():
    st.title("Equipment")
    render_table(list_equipment())

    st.subheader("Add Equipment and Purchase Record")
    departments = list_departments()
    department_map = {row["DepartmentName"]: row["DepartmentID"] for row in departments}
    vendors = list_vendors()
    vendor_map = {row["VendorName"]: row["VendorID"] for row in vendors}

    with st.form("add_equipment_form", clear_on_submit=True):
        name = st.text_input("Equipment Name")
        equipment_type = st.text_input("Type")
        unit = st.text_input("Unit", value="piece")
        department_name = st.selectbox("Department", list(department_map.keys()))
        vendor_name = st.selectbox("Vendor", list(vendor_map.keys()))
        purchase_date = st.date_input("Purchase Date")
        purchase_value = st.number_input("Purchase Value", min_value=0.0, step=50000.0)
        submitted = st.form_submit_button("Add Equipment")

        if submitted:
            if not name.strip() or not equipment_type.strip():
                st.error("Equipment name and type are required.")
            elif purchase_value <= 0:
                st.error("Purchase value must be greater than 0.")
            else:
                add_equipment_with_purchase(
                    name.strip(),
                    equipment_type.strip(),
                    unit.strip() or "piece",
                    department_map[department_name],
                    vendor_map[vendor_name],
                    purchase_date.isoformat(),
                    float(purchase_value),
                )
                st.success("Equipment and purchase record added successfully.")
                st.rerun()


def render_maintenance_page():
    st.title("Maintenance")
    maintenance_rows = list_maintenance()
    render_table(maintenance_rows)

    st.subheader("Add Maintenance")
    options = equipment_options()
    option_map = {
        f"{row['EquipmentID']} - {row['EquipmentName']}": row["EquipmentID"] for row in options
    }

    with st.form("add_maintenance_form", clear_on_submit=True):
        equipment_label = st.selectbox("Equipment", list(option_map.keys()))
        maintenance_date = st.date_input("Maintenance Date")
        description = st.text_area("Description")
        cost = st.number_input("Cost", min_value=0.0, step=50000.0)
        submitted = st.form_submit_button("Add Maintenance")

        if submitted:
            if not description.strip():
                st.error("Description is required.")
            else:
                add_maintenance(
                    option_map[equipment_label],
                    maintenance_date.isoformat(),
                    description.strip(),
                    float(cost),
                )
                st.success("Maintenance record added successfully.")
                st.rerun()

    st.subheader("Complete Maintenance")
    pending_rows = [row for row in maintenance_rows if row["Status"] != "Completed"]

    if not pending_rows:
        st.info("No pending maintenance records.")
    else:
        pending_map = {
            f"{row['MaintenanceID']} - {row['EquipmentName']} ({row['MaintenanceDate']})": row[
                "MaintenanceID"
            ]
            for row in pending_rows
        }

        with st.form("complete_maintenance_form"):
            maintenance_label = st.selectbox("Pending Maintenance", list(pending_map.keys()))
            submitted = st.form_submit_button("Mark as Completed")

            if submitted:
                complete_maintenance(pending_map[maintenance_label])
                st.success("Maintenance marked as completed.")
                st.rerun()

    st.subheader("Equipment Status Snapshot")
    render_table(list_equipment())


def render_reports_page():
    st.title("Reports")

    st.subheader("Total Asset Value")
    st.metric("Total Asset", f"{total_asset_value():,.0f}")

    st.subheader("Current Equipment Usage")
    render_table(current_equipment_usage())

    st.subheader("Maintenance Cost Report")
    render_table(maintenance_cost_report())


page = st.sidebar.radio(
    "Navigation",
    ["Dashboard", "Equipment", "Maintenance", "Reports"],
)

if page == "Dashboard":
    render_dashboard()
elif page == "Equipment":
    render_equipment_page()
elif page == "Maintenance":
    render_maintenance_page()
else:
    render_reports_page()
