DROP TABLE IF EXISTS mig_program;

CREATE TABLE mig_program (
  external_id varchar(255) NOT NULL,
  name varchar(255) NOT NULL,
  PRIMARY KEY (external_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP PROCEDURE IF EXISTS create_programs;
DELIMITER &&
CREATE PROCEDURE create_programs()
BEGIN    
  INSERT INTO mig_program (external_id, name) VALUES('technician_level', 'Technician Level');
  INSERT INTO mig_program (external_id, name) VALUES('specialist_icore_dual', 'Specialist I-Core/Dual Program');
  INSERT INTO mig_program (external_id, name) VALUES('specialist_acc_acc99d', 'Specialist ACC/ACC99D Program');
  INSERT INTO mig_program (external_id, name) VALUES('hunter_employee', 'Hunter Employee Program');
  INSERT INTO mig_program (external_id, name) VALUES('expert_program', 'Expert Program');
  INSERT INTO mig_program (external_id, name) VALUES('expert_installer', 'Expert Installer');
  INSERT INTO mig_program (external_id, name) VALUES('spanish_technician', 'Spanish Technician Program');
  INSERT INTO mig_program (external_id, name) VALUES('star_distributor', 'STAR Distributor Program');
  INSERT INTO mig_program (external_id, name) VALUES('hw_specialist', 'HW Specialist');
  INSERT INTO mig_program (external_id, name) VALUES('hydrawise_specialist_level', 'Hydrawise Specialist Level');
  INSERT INTO mig_program (external_id, name) VALUES('fx_lighting_design_level', 'FX Lighting Design Level');
  INSERT INTO mig_program (external_id, name) VALUES('fx_lighting_design', 'FX Lighting Design Program');
  INSERT INTO mig_program (external_id, name) VALUES('technician_2018', 'Technician 2018 Program');
  INSERT INTO mig_program (external_id, name) VALUES('hydrawise_specialist_workshop', 'Hydrawise Specialist Workshop');
  INSERT INTO mig_program (external_id, name) VALUES('hydrawise_expert_workshop', 'Hydrawise Expert Workshop');
  INSERT INTO mig_program (external_id, name) VALUES('irrigation_design_workshop_specialist', 'Irrigation Design Workshop Specialist');
  INSERT INTO mig_program (external_id, name) VALUES('irrigation_design_program', 'Irrigation Design Program');
  INSERT INTO mig_program (external_id, name) VALUES('fx_expert_workshop', 'FX Expert Workshop');
  INSERT INTO mig_program (external_id, name) VALUES('specialist_x2', 'Specialist X2');
END &&
DELIMITER ;

call create_programs();

select count(*) from mig_program;
