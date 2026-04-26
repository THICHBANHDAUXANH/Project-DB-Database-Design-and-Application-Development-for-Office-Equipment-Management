USE office_equipment_management;

CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeName VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE IF NOT EXISTS Vendors (
    VendorID INT PRIMARY KEY AUTO_INCREMENT,
    VendorName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Equipment (
    EquipmentID INT PRIMARY KEY AUTO_INCREMENT,
    EquipmentName VARCHAR(100) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Unit VARCHAR(50) DEFAULT 'piece',
    Status VARCHAR(30) DEFAULT 'Available',
    ConditionStatus VARCHAR(30) DEFAULT 'Good',
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE IF NOT EXISTS Purchases (
    PurchaseID INT PRIMARY KEY AUTO_INCREMENT,
    EquipmentID INT NOT NULL,
    VendorID INT,
    PurchaseDate DATE NOT NULL,
    Value DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID),
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID)
);

CREATE TABLE IF NOT EXISTS Maintenance (
    MaintenanceID INT PRIMARY KEY AUTO_INCREMENT,
    EquipmentID INT NOT NULL,
    MaintenanceDate DATE NOT NULL,
    Description TEXT,
    Cost DECIMAL(12,2) DEFAULT 0,
    Status VARCHAR(30) DEFAULT 'Scheduled',
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);
