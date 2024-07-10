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

DECLARE @DropConstraints NVARCHAR(max) = ''
SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.'
                        +  QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name)
FROM sys.foreign_keys
EXECUTE sp_executesql @DropConstraints;
GO

-- Borrado de funciones auxiliar si existe

DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_GetRangoEdadId;
DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_GetTurnoId;
DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_GetCuatrimestre;
DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_GetTiempoId;
DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_GetCategoriaId;
DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_GetUbicacionId;
DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_EnvioCumplido;

-- Borrado de vistas si existen en caso que el schema exista

IF OBJECT_ID('LOS_REZAGADOS.v_porcentaje_descuento_aplicados') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_porcentaje_descuento_aplicados
IF OBJECT_ID('LOS_REZAGADOS.v_cantidad_unidades_promedio') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_cantidad_unidades_promedio
IF OBJECT_ID('LOS_REZAGADOS.v_porcentaje_anual_ventas') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_porcentaje_anual_ventas
IF OBJECT_ID('LOS_REZAGADOS.v_cantidad_ventas_x_turno') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_cantidad_ventas_x_turno
IF OBJECT_ID('LOS_REZAGADOS.v_tres_categorias_mayor_descuento') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_tres_categorias_mayor_descuento
IF OBJECT_ID('LOS_REZAGADOS.v_porcentaje_cumplimiento_envio') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_porcentaje_cumplimiento_envio
IF OBJECT_ID('LOS_REZAGADOS.v_promedio_ventas') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_promedio_ventas;
IF OBJECT_ID('LOS_REZAGADOS.v_promedio_cuota_x_edad') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_promedio_cuota_x_edad;
IF OBJECT_ID('LOS_REZAGADOS.v_cant_envios_x_edad') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_cant_envios_x_edad;
IF OBJECT_ID('LOS_REZAGADOS.v_top5_localidades_costo_envio') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_top5_localidades_costo_envio;
IF OBJECT_ID('LOS_REZAGADOS.v_top3_sucursales_mayor_importe_pago_en_cuotas') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_top3_sucursales_mayor_importe_pago_en_cuotas;
IF OBJECT_ID('LOS_REZAGADOS.v_porcentaje_descuento_aplicados_por_medio_pago') IS NOT NULL
  DROP VIEW [LOS_REZAGADOS].v_porcentaje_descuento_aplicados_por_medio_pago;

-- Borrado de tablas si existen en caso que el schema exista

IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_pagos','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_pagos;
IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_ventas','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_ventas;
IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_envios','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_envios;
IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_promociones','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_promociones;
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
  medios_de_pago_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
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
  descripcion NVARCHAR (255)
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
WHERE [name] = 'BI_hechos_pagos')
CREATE TABLE [LOS_REZAGADOS].[BI_hechos_pagos]
(
  hechos_pagos_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  tiempo_id INT,
  sucursal_id INT,
  rango_cliente INT,
  medios_de_pago_id DECIMAL(18, 0),
  detalle_cuotas DECIMAL(18, 0),
  cantidad_ventas DECIMAL(18, 0),
  importe DECIMAL(18, 2),
  FOREIGN KEY(tiempo_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_tiempos],
  FOREIGN KEY(sucursal_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_categorias],
  FOREIGN KEY(rango_cliente) REFERENCES [LOS_REZAGADOS].[BI_dimension_rangos_edades],
  FOREIGN KEY(medios_de_pago_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_medios_de_pago],
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_hechos_promociones')
CREATE TABLE [LOS_REZAGADOS].[BI_hechos_promociones]
(
  hechos_promociones_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  anio INT,
  cuatrimestre INT,
  categoria_id INT,
  promo_aplicada_descuento DECIMAL(18, 2)
  FOREIGN KEY(categoria_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_categorias],
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_hechos_envios')
CREATE TABLE [LOS_REZAGADOS].[BI_hechos_envios]
(
  hechos_envios_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  tiempo_id INT,
  sucursal_id INT,
  rango_cliente INT,
  ubicacion_id INT,
  estado_envio NVARCHAR(255),
  envio_fecha_programada DATETIME,
  envio_fecha_entrega DATETIME,
  costo DECIMAL(18,2),
  FOREIGN KEY(sucursal_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_sucursales],
  FOREIGN KEY(tiempo_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_tiempos],
  FOREIGN KEY(rango_cliente) REFERENCES [LOS_REZAGADOS].[BI_dimension_rangos_edades],
  FOREIGN KEY(ubicacion_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_ubicaciones],
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_hechos_ventas')
CREATE TABLE [LOS_REZAGADOS].[BI_hechos_ventas]
(
  hechos_ventas_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  ubicacion_id INT,
  tiempo_id INT,
  rango_empleado INT,
  turno_id INT,
  cantidad_ventas DECIMAL (18, 2),
  caja_tipo NVARCHAR(255),
  ticket_sub_total DECIMAL(18, 2),
  producto DECIMAL(18, 2),
  ticket_detalle_cantidad DECIMAL(10, 0),
  ticket_total_descuento_promociones DECIMAL(18, 2),
  ticket_total_descuento_medio_pago DECIMAL(18, 2)
  FOREIGN KEY(ubicacion_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_ubicaciones],
  FOREIGN KEY(tiempo_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_tiempos],
  FOREIGN KEY(turno_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_turnos],
  FOREIGN KEY(rango_empleado) REFERENCES [LOS_REZAGADOS].[BI_dimension_rangos_edades],
)

COMMIT
GO

-- ================= Funciones auxiliares ==================

CREATE FUNCTION [LOS_REZAGADOS].fn_GetRangoEdadId(@fecha_nacimiento datetime) RETURNS INT AS
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

CREATE FUNCTION [LOS_REZAGADOS].fn_GetTurnoId(@fecha_compra DATETIME) RETURNS INT AS
BEGIN
  DECLARE @turno_id INT;
  DECLARE @hora INT;
  SET @hora = DATEPART(HOUR, @fecha_compra);

  -- Para simplificar, dado que los turnos tienen distinta hora_inicio, se compara solo contra esta
  IF @hora BETWEEN 8 AND 12
		SELECT @turno_id = turno_id
  FROM [LOS_REZAGADOS].BI_dimension_turnos AS T
  WHERE T.descripcion = '08:00 - 12:00'
	ELSE IF @hora BETWEEN 12 AND 16
		SELECT @turno_id = turno_id
  FROM [LOS_REZAGADOS].BI_dimension_turnos AS T
  WHERE T.descripcion = '12:00 - 16:00'
	ELSE IF @hora BETWEEN 16 AND 20
		SELECT @turno_id = turno_id
  FROM [LOS_REZAGADOS].BI_dimension_turnos AS T
  WHERE T.descripcion = '16:00 - 20:00'
	ELSE
		SELECT @turno_id = turno_id
  FROM [LOS_REZAGADOS].BI_dimension_turnos AS T
  WHERE T.descripcion = 'Otros'
  RETURN @turno_id;
END
GO

CREATE FUNCTION [LOS_REZAGADOS].fn_GetCuatrimestre(@fecha DATETIME) RETURNS SMALLINT AS
BEGIN
  RETURN (CEILING (DATEPART (mm,@fecha)* 1.0 / 4 ) )
END
GO

CREATE FUNCTION [LOS_REZAGADOS].fn_GetTiempoId(@fecha DATETIME) RETURNS INT AS
BEGIN
	DECLARE @anio INT,
			@mes INT,
			@cuatrimestre INT,
			@id_tiempo INT

	SET @anio = DATEPART(YEAR, @fecha)
	SET @mes = DATEPART(MONTH, @fecha)
	SET @cuatrimestre = [LOS_REZAGADOS].fn_GetCuatrimestre(@fecha)

	SELECT @id_tiempo = tiempo_id
		FROM LOS_REZAGADOS.BI_dimension_tiempos
		WHERE anio = @anio AND mes = @mes AND cuatrimestre = @cuatrimestre

	RETURN @id_tiempo
END
GO

CREATE FUNCTION [LOS_REZAGADOS].fn_GetCategoriaId(@categoria NVARCHAR(255), @subcategoria NVARCHAR(255)) RETURNS INT AS
BEGIN
    DECLARE @categoria_id INT

  	SELECT @categoria_id = categoria_id
		FROM [LOS_REZAGADOS].BI_dimension_categorias C
		WHERE C.categoria_descripcion = @categoria AND C.subcategoria_descripcion = @subcategoria

    RETURN @categoria_id
END
GO

CREATE FUNCTION [LOS_REZAGADOS].fn_GetUbicacionId(@localidad NVARCHAR(255), @provincia NVARCHAR(255)) RETURNS INT AS
BEGIN
    DECLARE @ubicacion INT

  	SELECT @ubicacion = U.ubicacion_id
		FROM [LOS_REZAGADOS].BI_dimension_ubicaciones U
		WHERE U.localidad_descripcion = @localidad AND U.provincia_descripcion = @provincia

    RETURN @ubicacion
END
GO

CREATE FUNCTION [LOS_REZAGADOS].fn_EnvioCumplido(@fechaEntregado DATETIME, @fechaProgramado DATETIME) RETURNS INT AS
BEGIN
  DECLARE @Cumplido INT;
  IF TRY_CAST(@fechaEntregado AS DATE) <= TRY_CAST(@fechaEntregado AS DATE)
	SET @Cumplido = 1
  ELSE
    SET @Cumplido = 0
  RETURN @Cumplido
END;
GO

-- ================= Carga datos =============================

BEGIN TRANSACTION

INSERT INTO [LOS_REZAGADOS].[BI_dimension_tiempos](
  mes,
  cuatrimestre,
  anio
)
SELECT DISTINCT MONTH(ticket_fecha_hora), [LOS_REZAGADOS].fn_GetCuatrimestre(ticket_fecha_hora), YEAR(ticket_fecha_hora)
FROM [LOS_REZAGADOS].Tickets_Venta
GO

INSERT INTO [LOS_REZAGADOS].[BI_dimension_categorias](
  categoria_descripcion,
  subcategoria_descripcion
)
SELECT C.categoria_descripcion, S.subcategoria_descripcion
FROM [LOS_REZAGADOS].Subcategorias S
JOIN [LOS_REZAGADOS].Categorias C ON S.categoria = C.categoria_id
GO

INSERT [LOS_REZAGADOS].[BI_dimension_medios_de_pago](
  descripcion,
  tipo_descripcion
)
SELECT M.descripcion, T.tipo_descripcion
FROM [LOS_REZAGADOS].Medios_de_pago M
JOIN [LOS_REZAGADOS].Tipos_medio_pago T ON M.tipo_id = T.tipo_id
GO

INSERT INTO [LOS_REZAGADOS].[BI_dimension_sucursales](
  supermercado,
  sucursal_nombre
)
SELECT Sup.supermercado_nombre, Suc.sucursal_nombre
FROM [LOS_REZAGADOS].Sucursales Suc
JOIN [LOS_REZAGADOS].Supermercados Sup ON Suc.supermercado = Sup.supermercado_id
GO

INSERT INTO [LOS_REZAGADOS].[BI_dimension_turnos](descripcion)
VALUES
  ('08:00 - 12:00'),
  ('12:00 - 16:00'),
  ('16:00 - 20:00'),
  ('Otros')
GO

INSERT INTO [LOS_REZAGADOS].[BI_dimension_rangos_edades](rango_descripcion)
VALUES
  ('< 25'),
  ('25 - 35'),
  ('35 - 50'),
  ('> 50')
GO

INSERT INTO [LOS_REZAGADOS].[BI_dimension_ubicaciones](
  localidad_descripcion,
  provincia_descripcion
)
SELECT L.localidad_descripcion, P.provincia_descripcion
FROM [LOS_REZAGADOS].Localidades L
JOIN [LOS_REZAGADOS].Provincias P ON L.provincia = P.provincia_id
GO

INSERT INTO [LOS_REZAGADOS].[BI_hechos_pagos](
  tiempo_id,
  sucursal_id,
  rango_cliente,
  medios_de_pago_id,
  detalle_cuotas,
  cantidad_ventas,
  importe
)
SELECT
  [LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
  C.sucursal,
  [LOS_REZAGADOS].fn_GetRangoEdadId(Cl.cliente_fecha_nacimiento),
  MP.medio_de_pago_id,
  DP.detalle_cuotas,
  COUNT(TV.ticket_id),
  SUM(ISNULL(PV.pago_importe, 0))
FROM [LOS_REZAGADOS].Tickets_Venta TV
LEFT JOIN [LOS_REZAGADOS].Cajas C ON TV.caja = C.caja_id
LEFT JOIN [LOS_REZAGADOS].Envios E ON TV.ticket_id = E.ticket_id
LEFT JOIN [LOS_REZAGADOS].Clientes Cl ON E.cliente = Cl.cliente_id
LEFT JOIN [LOS_REZAGADOS].Pagos_Ventas PV ON TV.ticket_id = PV.ticket_id
LEFT JOIN [LOS_REZAGADOS].Medios_de_pago MP ON PV.medio_de_pago = MP.medio_de_pago_id
LEFT JOIN [LOS_REZAGADOS].Detalles_pagos DP ON PV.detalle = DP.detalle_id
GROUP BY 
[LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
  C.sucursal,
  [LOS_REZAGADOS].fn_GetRangoEdadId(Cl.cliente_fecha_nacimiento),
  MP.medio_de_pago_id,
  DP.detalle_cuotas
GO

INSERT INTO [LOS_REZAGADOS].[BI_hechos_promociones](
  anio,
  cuatrimestre,
  categoria_id,
  promo_aplicada_descuento
)
SELECT
  YEAR(TV.ticket_fecha_hora),
  [LOS_REZAGADOS].fn_GetCuatrimestre(TV.ticket_fecha_hora),
  [LOS_REZAGADOS].fn_GetCategoriaId(C.categoria_descripcion, SC.subcategoria_descripcion),
  SUM(TVP.promo_aplicada_descuento)
FROM [LOS_REZAGADOS].Ticket_venta_x_producto TVP
JOIN [LOS_REZAGADOS].Productos P ON TVP.producto = P.producto_id
JOIN [LOS_REZAGADOS].Tickets_Venta TV ON TV.ticket_id = TVP.ticket_id
JOIN [LOS_REZAGADOS].Subcategorias_x_producto SP ON P.producto_id = SP.producto_id
JOIN [LOS_REZAGADOS].Subcategorias SC ON SP.subcategoria_id = SC.subcategoria_id
JOIN [LOS_REZAGADOS].Categorias C ON SC.categoria = C.categoria_id
GROUP BY
  YEAR(TV.ticket_fecha_hora),
  [LOS_REZAGADOS].fn_GetCuatrimestre(TV.ticket_fecha_hora),
  MONTH(TV.ticket_fecha_hora),
  [LOS_REZAGADOS].fn_GetCategoriaId(C.categoria_descripcion, SC.subcategoria_descripcion)
ORDER BY 1, 2, 3, 4
GO

INSERT INTO [LOS_REZAGADOS].[BI_hechos_ventas](
  ubicacion_id,
  tiempo_id,
  rango_empleado,
  turno_id,
  cantidad_ventas,
  caja_tipo,
  ticket_sub_total,
  producto,
  ticket_detalle_cantidad,
  ticket_total_descuento_promociones,
  ticket_total_descuento_medio_pago
)
SELECT
  [LOS_REZAGADOS].fn_GetUbicacionId(L.localidad_descripcion, P.provincia_descripcion),
  [LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
  [LOS_REZAGADOS].fn_GetRangoEdadId(E.empleado_fecha_nacimiento),
  [LOS_REZAGADOS].fn_GetTurnoId(TV.ticket_fecha_hora),
  COUNT(TV.ticket_id),
  C.caja_tipo,
  SUM(TV.ticket_sub_total_productos),
  COUNT(Pd.producto_id),
  SUM(TVP.ticket_det_cantidad),
  SUM(TV.ticket_total_descuento),
  SUM(TV.ticket_total_descuento_aplicado)
FROM [LOS_REZAGADOS].Tickets_Venta TV
JOIN [LOS_REZAGADOS].Cajas C ON TV.caja = C.caja_id
JOIN [LOS_REZAGADOS].Sucursales S ON C.sucursal = S.sucursal_id
JOIN [LOS_REZAGADOS].Localidades L ON S.sucursal_localidad = L.localidad_id
JOIN [LOS_REZAGADOS].Provincias P ON L.provincia = P.provincia_id
JOIN [LOS_REZAGADOS].Empleados E ON TV.empleado = E.empleado_id
JOIN [LOS_REZAGADOS].Ticket_venta_x_producto TVP ON TV.ticket_id = TVP.ticket_id
JOIN [LOS_REZAGADOS].Productos Pd ON TVP.producto = Pd.producto_id
GROUP BY [LOS_REZAGADOS].fn_GetUbicacionId(L.localidad_descripcion, P.provincia_descripcion),
  [LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
  [LOS_REZAGADOS].fn_GetRangoEdadId(E.empleado_fecha_nacimiento),
  [LOS_REZAGADOS].fn_GetTurnoId(TV.ticket_fecha_hora),
  C.caja_tipo
GO

INSERT INTO [LOS_REZAGADOS].[BI_hechos_envios](
  tiempo_id,
  sucursal_id,
  rango_cliente,
  ubicacion_id,
  estado_envio,
  envio_fecha_programada,
  envio_fecha_entrega,
  costo
)
SELECT DISTINCT
  [LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
  S.sucursal_id,
  [LOS_REZAGADOS].fn_GetRangoEdadId(Cl.cliente_fecha_nacimiento),
  [LOS_REZAGADOS].fn_GetUbicacionId(L.localidad_descripcion, P.provincia_descripcion),
  Ee.estado_descripcion,
  E.envio_fecha_programada,
  E.envio_fecha_entrega,
  SUM(E.envio_costo)
FROM [LOS_REZAGADOS].Envios E
LEFT JOIN [LOS_REZAGADOS].Tickets_Venta TV ON TV.ticket_id = E.ticket_id
JOIN [LOS_REZAGADOS].Cajas C ON TV.caja = C.caja_id
JOIN [LOS_REZAGADOS].Sucursales S ON C.sucursal = S.sucursal_id
JOIN [LOS_REZAGADOS].Clientes Cl ON E.cliente = Cl.cliente_id
JOIN [LOS_REZAGADOS].Localidades L ON Cl.cliente_localidad = L.localidad_id
JOIN [LOS_REZAGADOS].Provincias P ON L.provincia = P.provincia_id
LEFT JOIN [LOS_REZAGADOS].Estados_envios Ee ON E.estado = Ee.estado_id
GROUP BY 
	[LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
	[LOS_REZAGADOS].fn_GetRangoEdadId(Cl.cliente_fecha_nacimiento),
	[LOS_REZAGADOS].fn_GetUbicacionId(L.localidad_descripcion, P.provincia_descripcion),
	Ee.estado_descripcion,
	E.envio_fecha_programada,
	E.envio_fecha_entrega,
	S.sucursal_id
GO

COMMIT
GO

-- ================= Vistas =============================

-- -- Punto 1
-- CREATE VIEW [LOS_REZAGADOS].v_promedio_ventas AS
-- SELECT localidad_descripcion, anio, mes, AVG(ticket_sub_total) AS TotalMensual, SUM(ticket_sub_total) AS Total, SUM(ticket_nro) AS TotalVentas, COUNT(*) AS Cantidad
-- from [LOS_REZAGADOS].BI_hechos_ventas ventas
-- JOIN [LOS_REZAGADOS].BI_dimension_tiempos t
-- 	ON ventas.tiempo_id = t.tiempo_id
-- JOIN [LOS_REZAGADOS].BI_dimension_ubicaciones u
-- 	ON ventas.ubicacion_id = u.ubicacion_id
-- GROUP BY
-- 	localidad_descripcion, anio, mes
-- GO

-- -- Punto 2
-- CREATE VIEW [LOS_REZAGADOS].v_cantidad_unidades_promedio AS
-- SELECT
--     T.descripcion AS turno,
--     Ti.cuatrimestre AS cuatrimestre,
--     Ti.anio AS anio,
--     SUM(ticket_detalle_cantidad) / cantidad_ventas AS unidades_promedio
-- FROM [LOS_REZAGADOS].BI_hechos_ventas V
-- LEFT JOIN [LOS_REZAGADOS].BI_dimension_turnos T ON V.turno_id = T.turno_id
-- LEFT JOIN [LOS_REZAGADOS].BI_dimension_tiempos Ti ON V.tiempo_id = Ti.tiempo_id
-- GROUP BY T.descripcion, Ti.cuatrimestre, Ti.anio
-- GO

-- -- Punto 3

-- CREATE VIEW [LOS_REZAGADOS].v_porcentaje_anual_ventas AS
-- SELECT
--     Ti.anio,
--     Ti.cuatrimestre,
--     V.rango_empleado AS rango_etario_empleado,
--     V.caja_tipo,
--     (V.cantidad_ventas * 1.0) / (
--       SELECT SUM(cantidad_ventas)
--       FROM [LOS_REZAGADOS].BI_hechos_ventas V2
--       LEFT JOIN [LOS_REZAGADOS].BI_dimension_tiempos T2 ON V2.tiempo_id = T2.tiempo_id
--       WHERE T2.anio = Ti.anio
--     ) AS porcentaje_anual_ventas
-- FROM [LOS_REZAGADOS].BI_hechos_ventas V
-- LEFT JOIN [LOS_REZAGADOS].BI_dimension_turnos T ON V.turno_id = T.turno_id
-- LEFT JOIN [LOS_REZAGADOS].BI_dimension_tiempos Ti ON V.tiempo_id = Ti.tiempo_id
-- GROUP BY V.rango_empleado, V.caja_tipo, Ti.cuatrimestre, Ti.anio
-- GO

-- -- Punto 4

-- CREATE VIEW [LOS_REZAGADOS].v_cantidad_ventas_x_turno AS
-- SELECT
--     Ti.anio,
--     Ti.mes,
--     T.descripcion AS turno,
--     U.localidad_descripcion AS localidad,
--     COUNT(DISTINCT V.ticket_nro) AS ventas
-- FROM [LOS_REZAGADOS].BI_hechos_ventas V
-- JOIN [LOS_REZAGADOS].BI_dimension_turnos T ON V.turno_id = T.turno_id
-- JOIN [LOS_REZAGADOS].BI_dimension_ubicaciones U ON V.ubicacion_id = U.ubicacion_id
-- JOIN [LOS_REZAGADOS].BI_dimension_tiempos Ti ON V.tiempo_id = Ti.tiempo_id
-- GROUP BY Ti.anio, Ti.mes, T.descripcion, U.localidad_descripcion
-- GO

-- -- Punto 5

-- CREATE VIEW [LOS_REZAGADOS].v_porcentaje_descuento_aplicados AS
-- SELECT
--   t.anio AS Anio,
--   t.mes AS Mes,
--   SUM(hv.ticket_total_descuento_promociones + hv.ticket_total_descuento_medio_pago) AS TotalDescuentos,
--   SUM(hv.ticket_sub_total) AS TotalTickets,
--   TRY_CAST((SUM(hv.ticket_total_descuento_promociones + hv.ticket_total_descuento_medio_pago) / SUM(hv.ticket_sub_total)) * 100 AS DECIMAL(18,2)) AS PorcentajeDescuento
-- FROM [LOS_REZAGADOS].BI_hechos_ventas hv
-- INNER JOIN [LOS_REZAGADOS].BI_dimension_tiempos t on t.tiempo_id = hv.tiempo_id
-- GROUP BY t.anio, t.mes;
-- GO

-- -- Punto 6
-- CREATE VIEW [LOS_REZAGADOS].v_tres_categorias_mayor_descuento AS
-- SELECT * FROM (
--   SELECT
--     t.anio,
--     t.cuatrimestre,
--     dc.categoria_descripcion,
--     SUM(promo_aplicada_descuento) AS TotalDescuento,
--     ROW_NUMBER() OVER (PARTITION BY t.anio, t.cuatrimestre ORDER BY SUM(promo_aplicada_descuento) DESC) AS rnk
--   FROM [LOS_REZAGADOS].BI_hechos_promociones hp
--   INNER JOIN [LOS_REZAGADOS].BI_dimension_tiempos t
--     ON t.anio = hp.anio
--     AND t.cuatrimestre = hp.cuatrimestre
--   INNER JOIN [LOS_REZAGADOS].BI_dimension_categorias dc ON dc.categoria_id = hp.categoria_id
--   GROUP BY t.anio, t.cuatrimestre, dc.categoria_descripcion) RankingDescuentoPorCategoria
-- WHERE RankingDescuentoPorCategoria.rnk <= 3
-- GO

-- -- Punto 7

-- CREATE VIEW [LOS_REZAGADOS].v_porcentaje_cumplimiento_envio AS
-- SELECT
--   t.anio AS Anio,
--   t.mes AS Mes,
--   s.sucursal_nombre,
--   s.supermercado,
--   COUNT(1) AS TotalEnvios,
--   SUM([LOS_REZAGADOS].fn_EnvioCumplido(he.envio_fecha_entrega,he.envio_fecha_programada)) AS EnviosCumplidos,
--   (SUM([LOS_REZAGADOS].fn_EnvioCumplido(he.envio_fecha_entrega,he.envio_fecha_programada)) / COUNT(1)) * 100 AS PorcentajeCumplimientoEnvio
-- FROM [LOS_REZAGADOS].BI_hechos_envios he
-- INNER JOIN [LOS_REZAGADOS].BI_dimension_tiempos t ON t.tiempo_id = he.tiempo_id
-- INNER JOIN [LOS_REZAGADOS].BI_dimension_sucursales s on s.sucursal_id = he.sucursal_id
-- GROUP BY t.anio, t.mes, s.sucursal_nombre, s.supermercado;
-- GO

-- --Punto 8. Cantidad de env�os por rango etario de clientes para cada cuatrimestre de
-- --cada a�o.

-- CREATE VIEW [LOS_REZAGADOS].v_cant_envios_x_edad AS
-- SELECT COUNT(hechos_envios_id) AS CantidadEnvios, rango_descripcion, cuatrimestre, anio
-- FROM [LOS_REZAGADOS].BI_hechos_envios envio
-- JOIN LOS_REZAGADOS.BI_dimension_rangos_edades r 
-- 	ON r.rango_id = envio.rango_cliente
-- JOIN LOS_REZAGADOS.BI_dimension_tiempos t 
-- 	ON t.tiempo_id = envio.rango_cliente
-- GROUP BY rango_descripcion, cuatrimestre, anio
-- GO
-- -- Punto 9
-- --CREATE VIEW [LOS_REZAGADOS].v_top5_localidades_costo_envio AS
-- --SELECT TOP 5
-- --    DU.localidad_descripcion,
-- --    SUM(HE.costo) AS total_costo_envio
-- --FROM [LOS_REZAGADOS].BI_hechos_envios HE
-- --JOIN [LOS_REZAGADOS].BI_dimension_ubicaciones DU ON HE.ubicacion_id = DU.ubicacion_id
-- --GROUP BY DU.localidad_descripcion
-- --GO
-- CREATE VIEW [LOS_REZAGADOS].v_top5_localidades_costo_envio AS
-- SELECT
--     localidad_descripcion,
--     total_costo_envio
-- FROM (
--     SELECT TOP 5
--         DU.localidad_descripcion,
--         SUM(HE.costo) AS total_costo_envio
--     FROM [LOS_REZAGADOS].BI_hechos_envios HE
--     JOIN [LOS_REZAGADOS].BI_dimension_ubicaciones DU ON HE.ubicacion_id = DU.ubicacion_id
--     GROUP BY DU.localidad_descripcion
--     ORDER BY SUM(HE.costo) DESC
-- ) AS subquery;
-- GO
-- -- Punto 10

-- CREATE VIEW [LOS_REZAGADOS].v_top3_sucursales_mayor_importe_pago_en_cuotas AS
-- SELECT DISTINCT TOP 3
--     S.sucursal_nombre,
--     MP.descripcion,
--     SUM(P.importe) AS importe
-- FROM [LOS_REZAGADOS].BI_hechos_pagos P
-- JOIN [LOS_REZAGADOS].BI_dimension_sucursales S ON P.sucursal_id = S.sucursal_id
-- JOIN [LOS_REZAGADOS].BI_dimension_medios_de_pago MP ON P.medios_de_pago_id = MP.medios_de_pago_id
-- GROUP BY S.sucursal_nombre, MP.descripcion
-- HAVING MP.descripcion <> 'Efectivo'
-- GO

-- --11 Promedio de importe de la cuota en funci�n del rango etareo del cliente.
-- --no entiendo mucho la cuenta que hay que hacer
-- --SELECT rango_descripcion,
-- --    COALESCE(CONVERT(VARCHAR(255), AVG(importe / detalle_cuotas)), 'No hay cuotas registradas') AS promedio_importe_cuota
-- --FROM [LOS_REZAGADOS].BI_hechos_pagos
-- --JOIN [LOS_REZAGADOS].BI_dimension_rangos_edades ON BI_hechos_pagos.rango_cliente = BI_dimension_rangos_edades.rango_id
-- --GROUP BY rango_descripcion;
-- --GO
-- CREATE VIEW [LOS_REZAGADOS].v_promedio_cuota_x_edad AS
-- SELECT SUM(importe/detalle_cuotas) AS Promedio , rango_descripcion
-- FROM [LOS_REZAGADOS].BI_hechos_pagos pago
-- JOIN LOS_REZAGADOS.BI_dimension_rangos_edades r
-- 	ON r.rango_id = pago.rango_cliente
-- GROUP BY rango_descripcion
-- GO
-- -- Punto 12

-- CREATE VIEW [LOS_REZAGADOS].v_porcentaje_descuento_aplicados_por_medio_pago AS
-- SELECT
--     DP.tipo_descripcion AS Medio_de_Pago,
--     DT.cuatrimestre,
--     SUM(HV.ticket_sub_total) AS Total_Pagos_Sin_Descuento,
--     SUM(HV.ticket_total_descuento_medio_pago) AS Total_Descuentos_Aplicados,
--     (SUM(HV.ticket_total_descuento_medio_pago)/SUM(HV.ticket_sub_total)) * 100 AS Porcentaje_Descuento_Aplicado
-- FROM [LOS_REZAGADOS].BI_hechos_pagos HP
-- JOIN [LOS_REZAGADOS].BI_hechos_ventas HV ON HP.ticket_id = HV.ticket_nro
-- JOIN [LOS_REZAGADOS].BI_dimension_tiempos DT ON HP.tiempo_id = DT.tiempo_id
-- JOIN [LOS_REZAGADOS].BI_dimension_medios_de_pago DP ON HP.medios_de_pago_id = DP.medios_de_pago_id
-- GROUP BY DP.tipo_descripcion, DT.cuatrimestre;
-- GO
