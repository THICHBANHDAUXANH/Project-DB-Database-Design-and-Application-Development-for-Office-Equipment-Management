USE office_equipment_management;

DROP TRIGGER IF EXISTS trg_after_maintenance_update;
DROP PROCEDURE IF EXISTS AddMaintenance;
DROP FUNCTION IF EXISTS TotalAsset;
DROP VIEW IF EXISTS CurrentEquipmentUsage;
DROP VIEW IF EXISTS MaintenanceCostReport;

SET @drop_idx_equipment_type = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.statistics
            WHERE table_schema = DATABASE()
              AND table_name = 'Equipment'
              AND index_name = 'idx_equipment_type'
        ),
        'DROP INDEX idx_equipment_type ON Equipment',
        'SELECT ''idx_equipment_type not found'' AS Info'
    )
);
PREPARE stmt FROM @drop_idx_equipment_type;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @drop_idx_equipment_status = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.statistics
            WHERE table_schema = DATABASE()
              AND table_name = 'Equipment'
              AND index_name = 'idx_equipment_status'
        ),
        'DROP INDEX idx_equipment_status ON Equipment',
        'SELECT ''idx_equipment_status not found'' AS Info'
    )
);
PREPARE stmt FROM @drop_idx_equipment_status;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @drop_idx_maintenance_date = (
    SELECT IF(
        EXISTS (
            SELECT 1
            FROM information_schema.statistics
            WHERE table_schema = DATABASE()
              AND table_name = 'Maintenance'
              AND index_name = 'idx_maintenance_date'
        ),
        'DROP INDEX idx_maintenance_date ON Maintenance',
        'SELECT ''idx_maintenance_date not found'' AS Info'
    )
);
PREPARE stmt FROM @drop_idx_maintenance_date;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE INDEX idx_equipment_type ON Equipment(Type);
CREATE INDEX idx_equipment_status ON Equipment(Status);
CREATE INDEX idx_maintenance_date ON Maintenance(MaintenanceDate);

SELECT 'Indexes Created' AS Section;
SHOW INDEX FROM Equipment;
SHOW INDEX FROM Maintenance;

CREATE VIEW CurrentEquipmentUsage AS
SELECT
    e.EquipmentID,
    e.EquipmentName,
    e.Type,
    e.Unit,
    e.Status,
    e.ConditionStatus,
    d.DepartmentName
FROM Equipment e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

CREATE VIEW MaintenanceCostReport AS
SELECT
    e.EquipmentID,
    e.EquipmentName,
    COUNT(m.MaintenanceID) AS MaintenanceTimes,
    IFNULL(SUM(m.Cost), 0) AS TotalMaintenanceCost
FROM Equipment e
LEFT JOIN Maintenance m ON e.EquipmentID = m.EquipmentID
GROUP BY e.EquipmentID, e.EquipmentName;

SELECT 'CurrentEquipmentUsage View Output' AS Section;
SELECT * FROM CurrentEquipmentUsage ORDER BY EquipmentID;

SELECT 'MaintenanceCostReport View Output' AS Section;
SELECT * FROM MaintenanceCostReport ORDER BY TotalMaintenanceCost DESC, EquipmentID;

DELIMITER //

CREATE FUNCTION TotalAsset()
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT IFNULL(SUM(Value), 0) INTO total
    FROM Purchases;
    RETURN total;
END //

CREATE PROCEDURE AddMaintenance(
    IN p_EquipmentID INT,
    IN p_Date DATE,
    IN p_Description TEXT,
    IN p_Cost DECIMAL(12,2)
)
BEGIN
    INSERT INTO Maintenance (EquipmentID, MaintenanceDate, Description, Cost, Status)
    VALUES (p_EquipmentID, p_Date, p_Description, p_Cost, 'Scheduled');

    UPDATE Equipment
    SET Status = 'Maintenance'
    WHERE EquipmentID = p_EquipmentID;
END //

CREATE TRIGGER trg_after_maintenance_update
AFTER UPDATE ON Maintenance
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Completed' AND OLD.Status <> 'Completed' THEN
        UPDATE Equipment
        SET Status = 'Available', ConditionStatus = 'Good'
        WHERE EquipmentID = NEW.EquipmentID;
    END IF;
END //

DELIMITER ;

SELECT 'TotalAsset Function Output' AS Section;
SELECT TotalAsset() AS TotalAsset;

SELECT 'Before AddMaintenance Procedure' AS Section;
SELECT EquipmentID, EquipmentName, Status, ConditionStatus
FROM Equipment
WHERE EquipmentID = 5;

CALL AddMaintenance(
    5,
    '2026-05-10',
    'Scanner glass cleaning and calibration',
    250000
);

SELECT 'After AddMaintenance Procedure' AS Section;
SELECT EquipmentID, EquipmentName, Status, ConditionStatus
FROM Equipment
WHERE EquipmentID = 5;

SELECT MaintenanceID, EquipmentID, MaintenanceDate, Description, Cost, Status
FROM Maintenance
WHERE EquipmentID = 5
ORDER BY MaintenanceID DESC;

SELECT 'Before Trigger Update' AS Section;
SELECT EquipmentID, EquipmentName, Status, ConditionStatus
FROM Equipment
WHERE EquipmentID = 3;

UPDATE Maintenance
SET Status = 'Completed'
WHERE MaintenanceID = 1;

SELECT 'After Trigger Update' AS Section;
SELECT EquipmentID, EquipmentName, Status, ConditionStatus
FROM Equipment
WHERE EquipmentID = 3;

SELECT MaintenanceID, EquipmentID, MaintenanceDate, Description, Cost, Status
FROM Maintenance
WHERE MaintenanceID = 1;
