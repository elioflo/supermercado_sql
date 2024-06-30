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
-- Borrado de tablas si existen en caso que el schema exista

IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_pagos','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_pagos;
IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_ventas','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_ventas;
IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_envios','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_envios;
IF OBJECT_ID('LOS_REZAGADOS.BI_hechos_productos','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].BI_hechos_productos;
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
  ticket_id DECIMAL(18, 0),
  importe DECIMAL(18, 2),
  FOREIGN KEY(tiempo_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_tiempos],
  FOREIGN KEY(sucursal_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_categorias],
  FOREIGN KEY(rango_cliente) REFERENCES [LOS_REZAGADOS].[BI_dimension_rangos_edades],
  FOREIGN KEY(medios_de_pago_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_medios_de_pago],
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'BI_hechos_productos')
CREATE TABLE [LOS_REZAGADOS].[BI_hechos_productos]
(
  hechos_productos_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  tiempo_id INT,
  categoria_id INT,
  producto_id DECIMAL(18, 2),
  promo_aplicada_descuento DECIMAL(18, 2)
  FOREIGN KEY(tiempo_id) REFERENCES [LOS_REZAGADOS].[BI_dimension_tiempos],
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
  envio DECIMAL(18,0),
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
  ticket_nro DECIMAL (18, 2),
  caja_tipo NVARCHAR(255),
  ticket_sub_total DECIMAL(18, 2),
  producto DECIMAL(18, 2),
  ticket_detalle_cantidad DECIMAL(10, 0),
  descuentos DECIMAL(18, 2)
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
  ticket_id,
  importe
)
SELECT
  [LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
  C.sucursal,
  [LOS_REZAGADOS].fn_GetRangoEdadId(Cl.cliente_fecha_nacimiento),
  MP.medio_de_pago_id,
  DP.detalle_cuotas,
  TV.ticket_id,
  TV.ticket_sub_total_productos
FROM [LOS_REZAGADOS].Tickets_Venta TV
LEFT JOIN [LOS_REZAGADOS].Cajas C ON TV.caja = C.caja_id
LEFT JOIN [LOS_REZAGADOS].Envios E ON TV.ticket_id = E.ticket_id
LEFT JOIN [LOS_REZAGADOS].Clientes Cl ON E.cliente = Cl.cliente_id
LEFT JOIN [LOS_REZAGADOS].Pagos_Ventas PV ON TV.ticket_numero = PV.ticket_id
LEFT JOIN [LOS_REZAGADOS].Medios_de_pago MP ON PV.medio_de_pago = MP.medio_de_pago_id
LEFT JOIN [LOS_REZAGADOS].Detalles_pagos DP ON PV.detalle = DP.detalle_id
GO

-- Punto 11
-- Con los datos proporcionados no hay solucion, todos los valores de CLIENTE_FECHA_NACIMIENTO relacionados a PAGO_TARJETA_CUOTAS son nulos
-- SELECT DISTINCT PAGO_TARJETA_CUOTAS, CLIENTE_FECHA_NACIMIENTO FROM gd_esquema.Maestra
-- WHERE PAGO_TARJETA_CUOTAS IS NOT NULL

INSERT INTO [LOS_REZAGADOS].[BI_hechos_productos](
  tiempo_id,
  categoria_id,
  producto_id,
  promo_aplicada_descuento
)
SELECT
  [LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
  [LOS_REZAGADOS].fn_GetCategoriaId(C.categoria_descripcion, SC.subcategoria_descripcion),
  P.producto_id,
  TVP.promo_aplicada_descuento
FROM [LOS_REZAGADOS].Ticket_venta_x_producto TVP
JOIN [LOS_REZAGADOS].Productos P ON TVP.producto = P.producto_id
JOIN [LOS_REZAGADOS].Tickets_Venta TV ON TV.ticket_id = TVP.ticket_id
JOIN [LOS_REZAGADOS].Subcategorias_x_producto SP ON P.producto_id = SP.producto_id
JOIN [LOS_REZAGADOS].Subcategorias SC ON SP.subcategoria_id = SC.subcategoria_id
JOIN [LOS_REZAGADOS].Categorias C ON SC.categoria = C.categoria_id
GO

INSERT INTO [LOS_REZAGADOS].[BI_hechos_ventas](
  ubicacion_id,
  tiempo_id,
  rango_empleado,
  turno_id,
  ticket_nro,
  caja_tipo,
  ticket_sub_total,
  producto,
  ticket_detalle_cantidad,
  descuentos
)
SELECT
  [LOS_REZAGADOS].fn_GetUbicacionId(L.localidad_descripcion, P.provincia_descripcion),
  [LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
  [LOS_REZAGADOS].fn_GetRangoEdadId(E.empleado_fecha_nacimiento),
  [LOS_REZAGADOS].fn_GetTurnoId(TV.ticket_fecha_hora),
  TV.ticket_numero,
  C.caja_tipo,
  TV.ticket_sub_total_productos,
  Pd.producto_id,
  TVP.ticket_det_cantidad,
  TV.ticket_total_descuento + TV.ticket_total_descuento_aplicado AS descuentos
FROM [LOS_REZAGADOS].Tickets_Venta TV
JOIN [LOS_REZAGADOS].Cajas C ON TV.caja = C.caja_id
JOIN [LOS_REZAGADOS].Sucursales S ON C.sucursal = S.sucursal_id
JOIN [LOS_REZAGADOS].Localidades L ON S.sucursal_localidad = L.localidad_id
JOIN [LOS_REZAGADOS].Provincias P ON L.provincia = P.provincia_id
JOIN [LOS_REZAGADOS].Empleados E ON TV.empleado = E.empleado_id
JOIN [LOS_REZAGADOS].Ticket_venta_x_producto TVP ON TV.ticket_id = TVP.ticket_id
JOIN [LOS_REZAGADOS].Productos Pd ON TVP.producto = Pd.producto_id
GO

INSERT INTO [LOS_REZAGADOS].[BI_hechos_envios](
  tiempo_id,
  sucursal_id,
  rango_cliente,
  ubicacion_id,
  envio,
  estado_envio,
  envio_fecha_programada,
  envio_fecha_entrega,
  costo
)
SELECT
  [LOS_REZAGADOS].fn_GetTiempoId(TV.ticket_fecha_hora),
  S.sucursal_id,
  [LOS_REZAGADOS].fn_GetRangoEdadId(Cl.cliente_fecha_nacimiento),
  [LOS_REZAGADOS].fn_GetUbicacionId(L.localidad_descripcion, P.provincia_descripcion),
  E.envio_id,
  Ee.estado_descripcion,
  E.envio_fecha_programada,
  E.envio_fecha_entrega,
  E.envio_costo
FROM [LOS_REZAGADOS].Envios E
JOIN [LOS_REZAGADOS].Tickets_Venta TV ON TV.ticket_id = E.ticket_id
JOIN [LOS_REZAGADOS].Cajas C ON TV.caja = C.caja_id
JOIN [LOS_REZAGADOS].Sucursales S ON C.sucursal = S.sucursal_id
JOIN [LOS_REZAGADOS].Localidades L ON S.sucursal_localidad = L.localidad_id
JOIN [LOS_REZAGADOS].Provincias P ON L.provincia = P.provincia_id
JOIN [LOS_REZAGADOS].Clientes Cl ON E.cliente = Cl.cliente_id
LEFT JOIN [LOS_REZAGADOS].Estados_envios Ee ON E.estado = Ee.estado_id
GO

COMMIT
GO

-- hechos_ventas
-- .tiempo (cuatrimestre, mes, año)
-- .turno
-- .rango_empleado
-- .ubicacion

-- .caja
-- .ticket sub total (estrategia explicar es mas representativo) (1 , 5)
-- .ticket_num (Count ticket 1)
-- .sum productos (ticket detalle cant) Ticket_venta_x_producto
-- (Count tickets 3)
-- descuentos (suma ticket_total_descuento y ticket_total_descuento_aplicado)



-- hechos_producto 6
-- .tiempo (cuatrimestre)
-- .producto
-- .categoria
-- .promocion (monto)



-- hechos_envios 7
-- .tiempo (mes, cuatrimestre, año)
-- .ubicacion
-- .sucursal
-- .rango_cliente 8

-- .envio_id
-- .estado_envio
-- .envio_fecha_programado
-- .envio_fecha_entrega
-- Count (envio id)
-- .envio_costo




-- hechos_pagos 10
-- .tiempo (mes, año)
-- .cuotas
-- .sucursal
-- .venta?(ticket_id)
-- .importe (pagos_ventas)
-- .rango_cliente
-- v_ 12





-- INSERT INTO [LOS_REZAGADOS].[BI_hechos_ventas]
-- INSERT INTO [LOS_REZAGADOS].[BI_hechos_envios]

-- ================= Vistas =============================

-- Punto 5

CREATE VIEW [LOS_REZAGADOS].v_porcentaje_descuento_aplicados AS
SELECT 
  t.anio AS Anio,
  t.mes AS Mes,
  SUM(hv.descuentos) AS TotalDescuentos,
  SUM(hv.ticket_sub_total) AS TotalTickets,
  TRY_CAST((SUM(hv.descuentos) / SUM(hv.ticket_sub_total)) * 100 AS DECIMAL(18,2)) AS PorcentajeDescuento
FROM [LOS_REZAGADOS].BI_hechos_ventas hv
INNER JOIN [LOS_REZAGADOS].BI_dimension_tiempos t on t.tiempo_id = hv.tiempo_id
GROUP BY t.anio, t.mes;
GO


-- Punto 6

CREATE VIEW [LOS_REZAGADOS].v_tres_categorias_mayor_descuento AS
SELECT * FROM ( 
  SELECT
    t.anio,
    t.cuatrimestre,
    dc.categoria_descripcion,
    SUM(promo_aplicada_descuento) AS TotalDescuento,
    ROW_NUMBER() OVER (PARTITION BY t.anio, t.cuatrimestre ORDER BY SUM(promo_aplicada_descuento) DESC) AS rnk
  FROM [LOS_REZAGADOS].BI_hechos_productos hp
  INNER JOIN [LOS_REZAGADOS].BI_dimension_tiempos t ON t.tiempo_id = hp.tiempo_id
  INNER JOIN [LOS_REZAGADOS].BI_dimension_categorias dc ON dc.categoria_id = hp.categoria_id
  GROUP BY t.anio, t.cuatrimestre, dc.categoria_descripcion) RankingDescuentoPorCategoria
WHERE RankingDescuentoPorCategoria.rnk <= 3
GO

-- Punto 7

CREATE VIEW [LOS_REZAGADOS].v_porcentaje_cumplimiento_envio AS
SELECT 
  t.anio AS Anio,
  t.mes AS Mes,
  s.sucursal_nombre,
  s.supermercado,
  COUNT(1) AS TotalEnvios,
  SUM([LOS_REZAGADOS].fn_EnvioCumplido(he.envio_fecha_entrega,he.envio_fecha_programada)) AS EnviosCumplidos,
  (SUM([LOS_REZAGADOS].fn_EnvioCumplido(he.envio_fecha_entrega,he.envio_fecha_programada)) / COUNT(1)) * 100 AS PorcentajeCumplimientoEnvio
FROM [LOS_REZAGADOS].BI_hechos_envios he
INNER JOIN [LOS_REZAGADOS].BI_dimension_tiempos t on t.tiempo_id = he.tiempo_id
INNER JOIN [LOS_REZAGADOS].BI_dimension_sucursales s on s.sucursal_id = he.sucursal_id
GROUP BY t.anio, t.mes, s.sucursal_nombre, s.supermercado;
GO

-- --Punto 1
 CREATE VIEW [LOS_REZAGADOS].v_promedio_ventas AS
 SELECT 
     localidad_descripcion, 
     anio, 
     mes, 
     AVG(ticket_sub_total) AS Ticket_Promedio_Mensual
 FROM [LOS_REZAGADOS].BI_hechos_ventas
 JOIN [LOS_REZAGADOS].BI_dimension_ubicaciones ON BI_hechos_ventas.ubicacion_id = BI_dimension_ubicaciones.ubicacion_id
 JOIN [LOS_REZAGADOS].BI_dimension_tiempos ON BI_hechos_ventas.tiempo_id = BI_dimension_tiempos.tiempo_id
 GROUP BY localidad_descripcion, anio, mes;
GO
-- Punto 5

-- CREATE VIEW [LOS_REZAGADOS].v_porcentaje_descuento_aplicados AS
-- SELECT 
--     t.anio AS Anio,
--     t.mes AS Mes,
--     SUM(ticket_total_descuento) AS TotalDescuentos,
--     SUM(ticket_total_ticket) AS TotalTickets,
--     (SUM(ticket_total_descuento) / SUM(ticket_total_ticket)) * 100 AS PorcentajeDescuento
-- FROM [LOS_REZAGADOS].BI_dimension_ticket
-- INNER JOIN [LOS_REZAGADOS].BI_dimension_tiempos t on t.tiempo_id = tiempo
-- GROUP BY t.anio, t.mes;
-- GO

-- --Punto 8
 CREATE VIEW [LOS_REZAGADOS].v_cant_envios_x_edad AS
 SELECT 
     anio, 
     cuatrimestre, 
     rango_descripcion, 
     COUNT(envio) AS cantidad_envios
 FROM [LOS_REZAGADOS].BI_hechos_envios
 JOIN [LOS_REZAGADOS].BI_dimension_rangos_edades ON BI_hechos_envios.rango_cliente = BI_dimension_rangos_edades.rango_id
 JOIN [LOS_REZAGADOS].BI_dimension_tiempos ON BI_hechos_envios.tiempo_id = BI_dimension_tiempos.tiempo_id
 GROUP BY anio, cuatrimestre, rango_descripcion;
 GO


-- --Punto 9

-- CREATE VIEW [LOS_REZAGADOS].top_5_Localidades_Mayor_Costo_Envio 
-- AS
-- SELECT TOP 5
--     c.cliente_id,
--     SUM(e.envio_costo) AS total_costo_envio
-- FROM [LOS_REZAGADOS].Clientes c
-- JOIN [LOS_REZAGADOS].Envios e
-- 	ON c.cliente_id = e.cliente
-- GROUP BY c.cliente_id
-- ORDER BY total_costo_envio DESC
-- GO

-- --Punto 11
 CREATE VIEW [LOS_REZAGADOS].v_promedio_cuota_x_edad AS
 SELECT 
     rango_descripcion, 
	COALESCE(CONVERT(VARCHAR(255), AVG(importe / detalle_cuotas)), 'No hay cuotas registradas') AS promedio_importe_cuota
 FROM [LOS_REZAGADOS].BI_hechos_pagos
 JOIN [LOS_REZAGADOS].BI_dimension_rangos_edades ON BI_hechos_pagos.rango_cliente = BI_dimension_rangos_edades.rango_id
 GROUP BY rango_descripcion;
 GO
