-- Vistas de integridad referencial

-- Ingresos sin paciente válido
CREATE VIEW vw_pacientenull AS
SELECT i.ingreso_id,
       i.paciente_id
FROM admin.ingreso i
LEFT JOIN admin.paciente p ON i.paciente_id = p.paciente_id
WHERE p.paciente_id IS NULL;


-- Ingreso_diagnóstico sin ingreso válido
CREATE VIEW vw_ingresonull AS
SELECT id.ingreso_diag_id,
       id.ingreso_id,
       id.diag_id
FROM admin.ingreso_diagnostico id
LEFT JOIN admin.ingreso i ON id.ingreso_id = i.ingreso_id
WHERE i.ingreso_id IS NULL;

-- Ingreso_diagnóstico sin diagnostico válido
CREATE VIEW vw_diagnosticonull AS
SELECT id.ingreso_diag_id,
       id.ingreso_id,
       id.diag_id
FROM admin.ingreso_diagnostico id
LEFT JOIN admin.diagnostico d ON id.diag_id = d.diag_id
WHERE d.diag_id IS NULL;

-- Vistas de validación de datos

-- Pacientes sin año de nacimiento
CREATE VIEW vw_nacimientonull AS
SELECT paciente_id,
       pseudonimo,
       sexo
FROM admin.paciente
WHERE año_nacimiento IS NULL;

-- Ingresos con fechas inconsistentes
CREATE VIEW vw_fechasinconst AS
SELECT ingreso_id,
       fecha_ingreso,
       fecha_fin_contacto
FROM admin.ingreso
WHERE fecha_fin_contacto < fecha_ingreso;

-- Edad en ingreso fuera de rango
CREATE VIEW vw_edadinvalid AS
SELECT ingreso_id,
       edad_en_ingreso
FROM admin.ingreso
WHERE edad_en_ingreso < 0
   OR edad_en_ingreso > 120;

-- Estancias inusualmente largas
CREATE VIEW vw_estanciaslargas AS
SELECT ingreso_id,
       estancia_dias
FROM admin.ingreso
WHERE estancia_dias > 180;

-- Vistas de trazabilidad y auditoría

-- Auditoría general de eventos
CREATE VIEW vw_auditoria AS
SELECT 
   usuario,
   COUNT(*) AS total_eventos,
   MIN(fecha_evento) AS primer_evento,
   MAX(fecha_evento) AS ultimo_evento
FROM admin.auditoria
GROUP BY usuario;

-- Vista resumen para dashboard de calidad de datos

CREATE VIEW vw_datos_resumen AS
SELECT
   (SELECT COUNT(*) FROM admin.vw_ingresos_sin_paciente) AS ingresos_sin_paciente,
   (SELECT COUNT(*) FROM admin.vw_ingreso_diag_sin_ingreso) AS ingreso_diag_sin_ingreso,
   (SELECT COUNT(*) FROM admin.vw_ingreso_diag_sin_diag) AS ingreso_diag_sin_diag,
   (SELECT COUNT(*) FROM admin.vw_pacientes_sin_nacimiento) AS pacientes_sin_nacimiento,
   (SELECT COUNT(*) FROM admin.vw_fechas_inconsistentes) AS fechas_inconsistentes,
   (SELECT COUNT(*) FROM admin.vw_edades_invalidas) AS edades_invalidas,
   (SELECT COUNT(*) FROM admin.vw_estancias_largas) AS estancias_largas
FROM dual;

-- Ejecución

SELECT * FROM vw_datos_resumen;
SELECT * FROM vw_auditoria;
SELECT * FROM vw_estanciaslargas;

-- Automatización de eventos

CREATE TRIGGER admin.trg_paciente
AFTER INSERT OR UPDATE OR DELETE ON admin.paciente
FOR EACH ROW
DECLARE
   v_accion VARCHAR2(10);
BEGIN
   IF INSERTING THEN
      v_accion := 'INSERT';
   ELSIF UPDATING THEN
      v_accion := 'UPDATE';
   ELSIF DELETING THEN
      v_accion := 'DELETE';
   END IF;

   INSERT INTO admin.auditoria_eventos (
      usuario, accion, tabla_afectada, registro_id, descripcion
   ) VALUES (
      USER,
      v_accion,
      'ADMIN.PACIENTE',
      NVL(:NEW.paciente_id, :OLD.paciente_id),
      'Operación automática registrada en la tabla PACIENTE'
   );
END;
/

CREATE TRIGGER admin.trg_ingreso
AFTER INSERT OR UPDATE OR DELETE ON admin.ingreso
FOR EACH ROW
DECLARE
   v_accion VARCHAR2(10);
BEGIN
   IF INSERTING THEN
      v_accion := 'INSERT';
   ELSIF UPDATING THEN
      v_accion := 'UPDATE';
   ELSIF DELETING THEN
      v_accion := 'DELETE';
   END IF;

   INSERT INTO admin.auditoria_eventos (
      usuario, accion, tabla_afectada, registro_id, descripcion
   ) VALUES (
      USER,
      v_accion,
      'ADMIN.INGRESO',
      NVL(:NEW.ingreso_id, :OLD.ingreso_id),
      'Operación automática registrada en la tabla INGRESO'
   );
END;
/

CREATE TRIGGER admin.trg_diagnostico
AFTER INSERT OR UPDATE OR DELETE ON admin.diagnostico
FOR EACH ROW
DECLARE
   v_accion VARCHAR2(10);
BEGIN
   IF INSERTING THEN
      v_accion := 'INSERT';
   ELSIF UPDATING THEN
      v_accion := 'UPDATE';
   ELSIF DELETING THEN
      v_accion := 'DELETE';
   END IF;

   INSERT INTO admin.auditoria_eventos (
      usuario, accion, tabla_afectada, registro_id, descripcion
   ) VALUES (
      USER,
      v_accion,
      'ADMIN.DIAGNOSTICO',
      NVL(:NEW.diag_id, :OLD.diag_id),
      'Operación automática registrada en la tabla DIAGNOSTICO'
   );
END;
/

CREATE TRIGGER admin.trg_ingreso_diag
AFTER INSERT OR UPDATE OR DELETE ON admin.ingreso_diagnostico
FOR EACH ROW
DECLARE
   v_accion VARCHAR2(10);
BEGIN
   IF INSERTING THEN
      v_accion := 'INSERT';
   ELSIF UPDATING THEN
      v_accion := 'UPDATE';
   ELSIF DELETING THEN
      v_accion := 'DELETE';
   END IF;

   INSERT INTO admin.auditoria_eventos (
      usuario, accion, tabla_afectada, registro_id, descripcion
   ) VALUES (
      USER,
      v_accion,
      'ADMIN.INGRESO_DIAGNOSTICO',
      NVL(:NEW.ingreso_diag_id, :OLD.ingreso_diag_id),
      'Operación automática registrada en la tabla INGRESO_DIAGNOSTICO'
   );
END;
/
-- Vista analítica
CREATE VIEW admin.vw_resumen_ingresos AS
SELECT 
   p.sexo,
   p.año_nacimiento,
   i.tipo_alta,
   i.tipo_grd_apr,
   i.estancia_dias,
   COUNT(*) AS num_ingresos,
   AVG(i.estancia_dias) AS media_estancia
FROM admin.paciente p
JOIN admin.ingreso i ON p.paciente_id = i.paciente_id
GROUP BY p.sexo, p.año_nacimiento, i.tipo_alta, i.tipo_grd_apr, i.estancia_dias;

-- Cumplimiento normativo y seguridad
-- pseudonimización de nombre, DNI, dirección