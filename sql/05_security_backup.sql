USE office_equipment_management;

DROP ROLE IF EXISTS 'it_admin';
DROP ROLE IF EXISTS 'department_manager';
DROP ROLE IF EXISTS 'auditor';

CREATE ROLE 'it_admin';
CREATE ROLE 'department_manager';
CREATE ROLE 'auditor';

GRANT ALL PRIVILEGES ON office_equipment_management.* TO 'it_admin';

GRANT SELECT ON office_equipment_management.Departments TO 'department_manager';
GRANT SELECT ON office_equipment_management.Employees TO 'department_manager';
GRANT SELECT, INSERT, UPDATE ON office_equipment_management.Equipment TO 'department_manager';
GRANT SELECT, INSERT, UPDATE ON office_equipment_management.Maintenance TO 'department_manager';
GRANT SELECT ON office_equipment_management.Purchases TO 'department_manager';
GRANT SELECT ON office_equipment_management.Vendors TO 'department_manager';
GRANT EXECUTE ON FUNCTION office_equipment_management.TotalAsset TO 'department_manager';
GRANT EXECUTE ON PROCEDURE office_equipment_management.AddMaintenance TO 'department_manager';

GRANT SELECT ON office_equipment_management.* TO 'auditor';

SELECT 'Created Roles' AS Section;
SELECT 'it_admin' AS RoleName
UNION ALL
SELECT 'department_manager'
UNION ALL
SELECT 'auditor';

SELECT 'Role Privileges Overview' AS Section;
SELECT GRANTEE, TABLE_NAME, PRIVILEGE_TYPE
FROM information_schema.TABLE_PRIVILEGES
WHERE TABLE_SCHEMA = 'office_equipment_management'
  AND (
      GRANTEE LIKE '%it_admin%'
      OR GRANTEE LIKE '%department_manager%'
      OR GRANTEE LIKE '%auditor%'
  )
ORDER BY GRANTEE, TABLE_NAME, PRIVILEGE_TYPE;

SELECT 'Backup Command Example' AS Section;
SELECT 'mysqldump -u root -p office_equipment_management > office_equipment_management_backup.sql' AS BackupCommand;

SELECT 'Restore Command Example' AS Section;
SELECT 'mysql -u root -p office_equipment_management < office_equipment_management_backup.sql' AS RestoreCommand;
