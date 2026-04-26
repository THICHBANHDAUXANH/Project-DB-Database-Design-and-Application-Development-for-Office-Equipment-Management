USE office_equipment_management;

INSERT INTO Departments (DepartmentName) VALUES
('IT'),
('Accounting'),
('Human Resources'),
('Marketing'),
('Operations');

SELECT 'Departments Sample Data' AS Section;
SELECT * FROM Departments;

INSERT INTO Employees (EmployeeName, DepartmentID) VALUES
('Nguyen Van A', 1),
('Tran Thi B', 2),
('Le Van C', 3),
('Pham Thi D', 4),
('Hoang Van E', 5);

SELECT 'Employees Sample Data' AS Section;
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID;

INSERT INTO Vendors (VendorName, Phone, Email) VALUES
('FPT Shop', '0900000001', 'sales@fpt.vn'),
('Phong Vu', '0900000002', 'contact@phongvu.vn'),
('The Gioi Di Dong', '0900000003', 'business@tgdd.vn');

SELECT 'Vendors Sample Data' AS Section;
SELECT * FROM Vendors;

INSERT INTO Equipment (EquipmentName, Type, Unit, Status, ConditionStatus, DepartmentID) VALUES
('Dell Latitude 5420', 'Laptop', 'piece', 'Assigned', 'Good', 1),
('HP LaserJet Pro', 'Printer', 'piece', 'Available', 'Good', 2),
('Epson EB-X49', 'Projector', 'piece', 'Maintenance', 'Needs Repair', 4),
('Cisco Router 2901', 'Network Device', 'piece', 'Assigned', 'Good', 1),
('Canon Scanner Lide 300', 'Scanner', 'piece', 'Available', 'Good', 5);

SELECT 'Equipment Sample Data' AS Section;
SELECT e.EquipmentID, e.EquipmentName, e.Type, e.Status, e.ConditionStatus, d.DepartmentName
FROM Equipment e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EquipmentID;

INSERT INTO Purchases (EquipmentID, VendorID, PurchaseDate, Value) VALUES
(1, 1, '2025-01-10', 18500000),
(2, 2, '2025-02-15', 5200000),
(3, 2, '2025-03-20', 12500000),
(4, 3, '2025-04-05', 9800000),
(5, 1, '2025-05-12', 3100000);

SELECT 'Purchases Sample Data' AS Section;
SELECT p.PurchaseID, e.EquipmentName, v.VendorName, p.PurchaseDate, p.Value
FROM Purchases p
JOIN Equipment e ON p.EquipmentID = e.EquipmentID
LEFT JOIN Vendors v ON p.VendorID = v.VendorID
ORDER BY p.PurchaseID;

INSERT INTO Maintenance (EquipmentID, MaintenanceDate, Description, Cost, Status) VALUES
(3, '2026-04-20', 'Replace projector lamp and clean filter', 1200000, 'Scheduled'),
(2, '2026-04-22', 'Printer toner replacement', 650000, 'Completed'),
(1, '2026-05-01', 'Laptop battery health check', 0, 'Scheduled');

SELECT 'Maintenance Sample Data' AS Section;
SELECT m.MaintenanceID, e.EquipmentName, m.MaintenanceDate, m.Description, m.Cost, m.Status
FROM Maintenance m
JOIN Equipment e ON m.EquipmentID = e.EquipmentID
ORDER BY m.MaintenanceID;

SELECT 'Equipment by Department' AS Section;
SELECT d.DepartmentName, COUNT(e.EquipmentID) AS TotalEquipment
FROM Departments d
LEFT JOIN Equipment e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY TotalEquipment DESC, d.DepartmentName;

SELECT 'Total Purchase Value by Vendor' AS Section;
SELECT v.VendorName, SUM(p.Value) AS TotalPurchaseValue
FROM Vendors v
JOIN Purchases p ON v.VendorID = p.VendorID
GROUP BY v.VendorID, v.VendorName
ORDER BY TotalPurchaseValue DESC;

SELECT 'Maintenance Cost by Equipment' AS Section;
SELECT e.EquipmentName, SUM(m.Cost) AS TotalMaintenanceCost
FROM Equipment e
LEFT JOIN Maintenance m ON e.EquipmentID = m.EquipmentID
GROUP BY e.EquipmentID, e.EquipmentName
ORDER BY TotalMaintenanceCost DESC, e.EquipmentName;
