USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Creacion de schema si no existe

IF NOT EXISTS ( SELECT *
FROM sys.schemas
WHERE name = 'LOS_REZAGADOS')
BEGIN
  EXECUTE('CREATE SCHEMA LOS_REZAGADOS')
END
GO

-- Borrado de FK Constraints

-- DECLARE @DropConstraints NVARCHAR(max) = ''
-- SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.'
--                         +  QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name)
-- FROM sys.foreign_keys
-- EXECUTE sp_executesql @DropConstraints;
-- GO

-- Borrado de funciones auxiliar si existe

DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_GetRangoEdadId;
DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_GetTurnoId;

-- Borrado de vistas si existen en caso que el schema exista

IF OBJECT_ID('LOS_REZAGADOS.v_porcentaje_descuento_aplicados') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_porcentaje_descuento_aplicados

-- Borrado de tablas si existen en caso que el schema exista

IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_descuentos','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_descuentos;
IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_ventas','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_ventas;
IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_envios','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_envios;
IF OBJECT_ID('LOS_REZAGADOS.BI_dimension_tiempos','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_dimension_tiempos;
IF OBJECT_ID('LOS_REZAGADOS.BI_dimension_medios_de_pago','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_dimension_medios_de_pago;
IF OBJECT_ID('LOS_REZAGADOS.BI_dimension_categorias','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_dimension_categorias;
IF OBJECT_ID('LOS_REZAGADOS.BI_dimension_ubicaciones','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_dimension_ubicaciones;
IF OBJECT_ID('LOS_REZAGADOS.BI_dimension_rangos_edades','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_dimension_rangos_edades;
IF OBJECT_ID('LOS_REZAGADOS.BI_dimension_turnos','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_dimension_turnos;
IF OBJECT_ID('LOS_REZAGADOS.BI_dimension_sucursales','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_dimension_sucursales;
IF OBJECT_ID('LOS_REZAGADOS.BI_dimension_ticket','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_dimension_ticket;

-- Creacion de tablas
BEGIN TRANSACTION

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_dimension_tiempos')
CREATE TABLE [LOS_REZAGADOS].[BI_dimension_tiempos]
(
  tiempo_id INT IDENTITY(1,1) PRIMARY KEY,
  mes INT,
  cuatrimestre INT,
  anio INT
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_dimension_ticket')
CREATE TABLE [LOS_REZAGADOS].[BI_dimension_ticket]
(
  ticket_id INT PRIMARY KEY,
  tiempo INT NOT NULL,
  ticket_total_descuento DECIMAL(18, 2),
  ticket_total_ticket DECIMAL(18, 2)
)

ALTER TABLE [LOS_REZAGADOS].[BI_dimension_ticket]
ADD FOREIGN KEY (tiempo) REFERENCES [LOS_REZAGADOS].BI_dimension_tiempos(tiempo_id);


IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_dimension_categorias')
CREATE TABLE [LOS_REZAGADOS].[BI_dimension_categorias]
(
  categoria_id INT IDENTITY(1,1) PRIMARY KEY,
  categoria_descripcion NVARCHAR (255),
  subcategoria_descripcion NVARCHAR (255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_dimension_medios_de_pago')
CREATE TABLE [LOS_REZAGADOS].[BI_dimension_medios_de_pago]
(
  medios_de_pago_id INT IDENTITY(1,1) PRIMARY KEY,
  descripcion NVARCHAR (255),
  tipo_descripcion NVARCHAR (255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_dimension_sucursales')
CREATE TABLE [LOS_REZAGADOS].[BI_dimension_sucursales]
(
  sucursal_id INT IDENTITY(1,1) PRIMARY KEY,
  supermercado NVARCHAR (255),
  sucursal_nombre NVARCHAR (255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_dimension_turnos')
CREATE TABLE [LOS_REZAGADOS].[BI_dimension_turnos]
(
  turno_id INT IDENTITY(1,1) PRIMARY KEY,
  hora_inicio INT,
  hora_fin INT,
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_dimension_rangos_edades')
CREATE TABLE [LOS_REZAGADOS].[BI_dimension_rangos_edades]
(
  rango_id INT IDENTITY(1,1) PRIMARY KEY,
  rango_descripcion NVARCHAR (255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_dimension_ubicaciones')
CREATE TABLE [LOS_REZAGADOS].[BI_dimension_ubicaciones]
(
  ubicacion_id INT IDENTITY(1,1) PRIMARY KEY,
  localidad_descripcion NVARCHAR (255),
  provincia_descripcion NVARCHAR (255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_hechos_descuentos')
CREATE TABLE [LOS_REZAGADOS].[BI_hechos_descuentos]
(
  tiempo_id INT,
  categoria_id INT,
  medio_de_pago_id INT,
  PRIMARY KEY(tiempo_id, categoria_id, medio_de_pago_id),
  FOREIGN KEY(tiempo_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_tiempos],
  FOREIGN KEY(categoria_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_categorias],
  FOREIGN KEY(medio_de_pago_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_medios_de_pago],
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_hechos_envios')
CREATE TABLE [LOS_REZAGADOS].[BI_hechos_envios]
(
  sucursal_id INT,
  tiempo_id INT,
  rango_id INT,
  ubicacion_id INT,
  PRIMARY KEY(sucursal_id, tiempo_id, rango_id, ubicacion_id),
  FOREIGN KEY(sucursal_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_sucursales],
  FOREIGN KEY(tiempo_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_tiempos],
  FOREIGN KEY(rango_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_rangos_edades],
  FOREIGN KEY(ubicacion_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_ubicaciones],
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_hechos_ventas')
CREATE TABLE [LOS_REZAGADOS].[BI_hechos_ventas]
(
  ubicacion_id INT,
  tiempo_id INT,
  rango_empleado INT,
  rango_cliente INT,
  turno_id INT,
  caja_tipo INT,
  PRIMARY KEY(ubicacion_id, tiempo_id, rango_empleado, rango_cliente, turno_id),
  FOREIGN KEY(ubicacion_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_ubicaciones],
  FOREIGN KEY(tiempo_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_tiempos],
  FOREIGN KEY(turno_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_turnos],
  FOREIGN KEY(rango_empleado) REFERENCES [LOS_REZAGADOS].[BI_dimension_rangos_edades],
  FOREIGN KEY(rango_cliente) REFERENCES [LOS_REZAGADOS].[BI_dimension_rangos_edades],
)

COMMIT
GO

-- ================= Funciones auxiliares ==================

CREATE FUNCTION [LOS_REZAGADOS].fn_GetRangoEdadId(@fecha_nacimiento DATE) RETURNS INT AS
BEGIN
  DECLARE @rango_id INT;
  DECLARE @edad INT;
  SET @edad = (DATEDIFF(DAY, @fecha_nacimiento, GETDATE()) / 365)

  IF @edad BETWEEN 0 AND 24
		SELECT @rango_id = rango_id
  FROM [LOS_REZAGADOS].BI_dimension_rangos_edades
  WHERE rango_descripcion = '< 25'
	ELSE IF @edad BETWEEN 25 AND 34
		SELECT @rango_id = rango_id
  FROM [LOS_REZAGADOS].BI_dimension_rangos_edades
  WHERE rango_descripcion = '25 - 35'
	ELSE IF @edad BETWEEN 35 AND 50
		SELECT @rango_id = rango_id
  FROM [LOS_REZAGADOS].BI_dimension_rangos_edades
  WHERE rango_descripcion = '35 - 50'
	ELSE
		SELECT @rango_id = rango_id
  FROM [LOS_REZAGADOS].BI_dimension_rangos_edades
  WHERE rango_descripcion = '> 50'
  RETURN @rango_id;
END
GO

CREATE FUNCTION [LOS_REZAGADOS].fn_GetTurnoId(@fecha_compra DATE) RETURNS INT AS
BEGIN
  DECLARE @turno_id INT;
  DECLARE @hora INT;
  SET @hora = DATEPART(HOUR, @fecha_compra);

  -- Para simplificar, dado que los turnos tienen distinta hora_inicio, se compara solo contra esta
  IF @hora BETWEEN 8 AND 12
		SELECT @turno_id = turno_id
  FROM [LOS_REZAGADOS].BI_dimension_turnos AS T
  WHERE T.hora_inicio = 8
	ELSE IF @hora BETWEEN 12 AND 16
		SELECT @turno_id = turno_id
  FROM [LOS_REZAGADOS].BI_dimension_turnos AS T
  WHERE T.hora_inicio = 12
	ELSE
		SELECT @turno_id = turno_id
  FROM [LOS_REZAGADOS].BI_dimension_turnos AS T
  WHERE T.hora_inicio = 16
  RETURN @turno_id;
END
GO

-- ================= Carga datos =============================

INSERT INTO [LOS_REZAGADOS].[BI_dimension_tiempos](
  mes,
  cuatrimestre,
  anio
)
SELECT DISTINCT MONTH(ticket_fecha_hora), DATEPART(QUARTER, ticket_fecha_hora), YEAR(ticket_fecha_hora)
FROM [LOS_REZAGADOS].Tickets_Venta

INSERT INTO [LOS_REZAGADOS].[BI_dimension_ticket] ([ticket_id], [tiempo], [ticket_total_descuento], [ticket_total_ticket])
SELECT DISTINCT 
	ticket_id, 
	t.tiempo_id,
	ticket_total_descuento,
	ticket_total_ticket
FROM [LOS_REZAGADOS].[Tickets_Venta]
INNER JOIN [LOS_REZAGADOS].[BI_dimension_tiempos] t ON MONTH(ticket_fecha_hora) = t.mes AND YEAR(ticket_fecha_hora) = t.anio;
GO

INSERT INTO [LOS_REZAGADOS].[BI_dimension_categorias](
  categoria_descripcion,
  subcategoria_descripcion
)
SELECT S.subcategoria_descripcion, C.categoria_descripcion
FROM [LOS_REZAGADOS].Subcategorias S
JOIN [LOS_REZAGADOS].Categorias C ON S.categoria = C.categoria_id

INSERT [LOS_REZAGADOS].[BI_dimension_medios_de_pago](
  descripcion,
  tipo_descripcion
)
SELECT M.descripcion, T.tipo_descripcion
FROM [LOS_REZAGADOS].Medios_de_pago M
JOIN [LOS_REZAGADOS].Tipos_medio_pago T ON M.tipo_id = T.tipo_descripcion

INSERT INTO [LOS_REZAGADOS].[BI_dimension_sucursales](
  supermercado,
  sucursal_nombre
)
SELECT Sup.supermercado_nombre, Suc.sucursal_nombre
FROM [LOS_REZAGADOS].Sucursales Suc
JOIN [LOS_REZAGADOS].Supermercados Sup ON Suc.supermercado = Sup.supermercado_id

INSERT INTO [LOS_REZAGADOS].[BI_dimension_turnos](
  hora_inicio,
  hora_fin
)
VALUES
  (8, 12),
  (12, 16),
  (16, 20)

INSERT INTO [LOS_REZAGADOS].[BI_dimension_rangos_edades](rango_descripcion)
VALUES
  ('< 25'),
  ('25 - 35'),
  ('35 - 50'),
  ('> 50')

INSERT INTO [LOS_REZAGADOS].[BI_dimension_ubicaciones](
  localidad_descripcion,
  provincia_descripcion
)
SELECT L.localidad_descripcion, P.provincia_descripcion
FROM [LOS_REZAGADOS].Localidades L
JOIN [LOS_REZAGADOS].Provincias P ON L.provincia = P.provincia_id
GO
-- ================= Vistas =============================


-- Punto 5

CREATE VIEW [LOS_REZAGADOS].v_porcentaje_descuento_aplicados AS
SELECT 
    t.anio AS Anio,
    t.mes AS Mes,
    SUM(ticket_total_descuento) AS TotalDescuentos,
    SUM(ticket_total_ticket) AS TotalTickets,
    (SUM(ticket_total_descuento) / SUM(ticket_total_ticket)) * 100 AS PorcentajeDescuento
FROM [LOS_REZAGADOS].BI_dimension_ticket
INNER JOIN [LOS_REZAGADOS].BI_dimension_tiempos t on t.tiempo_id = tiempo
GROUP BY t.anio, t.mes;
GO
--Punto 9

CREATE VIEW Top_5_Localidades_Mayor_Costo_Envio 
AS
SELECT TOP 5
    c.cliente_id,
    SUM(e.envio_costo) AS total_costo_envio
FROM LOS_REZAGADOS.Clientes c
JOIN LOS_REZAGADOS.Envios e
	ON c.cliente_id = e.cliente
GROUP BY c.cliente_id
ORDER BY total_costo_envio DESC
GO